import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/purchasing/mixin/purchasing_view_mixin.dart';
import 'package:flutter_supabase_google_odeme/product/extension/show_snackbar.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> with PurchasingViewMixin {
  final String functionName = 'rapid-function';
  bool isVerifying = false;

  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseData2 = {};
  // Satın almayı doğrula
  Future<void> satinAlimiDogrula(Map<String, String> purchaseData) async {
    setState(() => isVerifying = true);
    try {
      final response = await locator.supabaseFunctionService.callFunction(
        functionName: functionName,
        body: purchaseData,
      );
      locator.loggerService.i('✅ Doğrulama Cevabı: $response');
      responseData = response;
      setState(() {});
      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }
      // Başarılı doğrulama
      if (mounted) {
        context.showSnackBar('✅ Satın alma doğrulandı!', isError: false);
      }
    } catch (e) {
      locator.loggerService.e('❌ Doğrulama hatası: $e');
      if (mounted) {
        context.showSnackBar('❌ Doğrulama hatası: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isVerifying = false);
      }
    }
  }

  // Satın alma güncellemelerini dinle
  @override
  void onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        final info = await PackageInfo.fromPlatform();
        final packageName = info.packageName;
        final productId = purchase.productID;
        final token = purchase.verificationData.serverVerificationData;

        final purchaseData = {
          'packageName': packageName,
          'productId': productId,
          'purchaseToken': token,
        };
        responseData2 = purchaseData;
        setState(() {});

        // Doğrulama yap
        await satinAlimiDogrula(purchaseData);

        // ✅ Satın almayı tamamla
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        locator.loggerService.e('❌ Satın alma hatası: ${purchase.error}');
        if (mounted) {
          context.showSnackBar(
            'Hata: ${purchase.error?.message}',
            isError: true,
          );
        }
      } else if (purchase.status == PurchaseStatus.canceled) {
        locator.loggerService.w('⚠️ Satın alma iptal edildi');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Satın Al')),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(responseData.toString()),
                  Text(responseData2.toString()),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: () {}, child: Text(functionName)),
                ],
              ),
            ),
          ),

          Expanded(
            child: isVerifying
                ? const Center(child: CircularProgressIndicator())
                : !isAvailable
                ? const Center(child: Text('Play Billing kullanılabilir değil'))
                : products.isEmpty
                ? const Center(child: Text('Ürün bulunamadı'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.title),
                        subtitle: Text(product.description),
                        trailing: Text(product.price),
                        onTap: () => buyProduct(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
