import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({super.key});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _available = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      debugPrint('Play Billing kullanılabilir değil');
      return;
    }

    const Set<String> ids = {'supa1tl'};
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(ids);

    if (response.error != null) {
      debugPrint('Ürün sorgulama hatası: ${response.error}');
    }

    setState(() {
      _products = response.productDetails;
    });

    // Satın alma akışını dinle
    _subscription = _inAppPurchase.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          debugPrint('Satın alma başarılı: ${purchase.productID}');
          // 🔒 Burada sunucu doğrulaması yapabilirsin
        } else if (purchase.status == PurchaseStatus.error) {
          debugPrint('Satın alma hatası: ${purchase.error}');
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _buyProduct(ProductDetails product) async {
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: param);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Satın Al')),
      body: !_available
          ? const Center(child: Text('Play Billing kullanılabilir değil'))
          : _products.isEmpty
          ? const Center(child: Text('Ürün bulunamadı'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.description),
                  trailing: Text(product.price),
                  onTap: () => _buyProduct(product),
                );
              },
            ),
    );
  }
}
