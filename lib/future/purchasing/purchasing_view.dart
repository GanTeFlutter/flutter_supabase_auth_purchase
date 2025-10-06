// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/purchasing/mixin/purchasing_view_mixin.dart';
import 'package:flutter_supabase_google_odeme/main.dart';
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

  Future<void> satinAlimiDogrula(Map<String, String> purchaseData) async {
    setState(() => isVerifying = true);
    try {
      final response = await locator.supabaseFunctionService.callFunction(
        functionName: functionName,
        body: purchaseData,
      );
      responseData = response;
      setState(() {});
      if (mounted) {
        context.showSnackBar('✅ Satın alma doğrulandı!', isError: false);
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('❌ Doğrulama hatası: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isVerifying = false);
      }
    }
  }

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
        locator.supabaseService
            .insertToken(
              userId: supabase.auth.currentUser!.id,
              packageName: packageName,
              productId: productId,
              purchaseToken: token,
            )
            .then((success) {
              if (success) {
                context.showSnackBar(
                  '✅ Token veritabanına kaydedildi',
                  isError: true,
                );
              } else {
                context.showSnackBar(
                  '❌ Token veritabanına kaydedilemedi',
                  isError: true,
                );
              }
            });
        responseData2 = purchaseData;
        setState(() {});
        await satinAlimiDogrula(purchaseData);

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
          // Üst bilgi alanı
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // sola hizala
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text widget'ları artık düzgün biçimde alt alta yayılacak
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'functionName: $functionName',
                      style: const TextStyle(fontSize: 16),
                      softWrap: true, // uzun satırlarda otomatik alt satıra geç
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      responseData.toString(),
                      style: const TextStyle(fontSize: 15),
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      responseData2.toString(),
                      style: const TextStyle(fontSize: 15),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 1),

          // Ürün listesi alanı
          Expanded(
            child: isVerifying
                ? const Center(child: CircularProgressIndicator())
                : !isAvailable
                ? const Center(child: Text('Play Billing kullanılabilir değil'))
                : products.isEmpty
                ? const Center(child: Text('Ürün bulunamadı'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(product.title),
                          subtitle: Text(product.description),
                          trailing: Text(product.price),
                          onTap: () => buyProduct(product),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
