import 'dart:async';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasingService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  List<ProductDetails> _products = [];
  bool _available = false;

  List<ProductDetails> get products => _products;
  bool get isAvailable => _available;

  Future<void> initialize() async {
    _available = await _inAppPurchase.isAvailable();
    if (!_available) {
      locator.loggerService.e('Play Billing kullanılabilir değil');
      return;
    }

    const Set<String> ids = {'finaltest'};
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(ids);

    if (response.error != null) {
      locator.loggerService.e('Ürün sorgulama hatası: ${response.error}');
    }

    _products = response.productDetails;
  }

  void startListeningToPurchases(
    Function(List<PurchaseDetails>) onPurchaseUpdate,
  ) {
    _subscription = _inAppPurchase.purchaseStream.listen((purchases) {
      onPurchaseUpdate(purchases);
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          locator.loggerService.i('Satın alma başarılı: ${purchase.productID}');
          String? purchaseToken =
              purchase.verificationData.serverVerificationData;
          locator.loggerService.i('Purchase Token: $purchaseToken');
          locator.loggerService.i('Product ID: ${purchase.productID}');
          //
        } else if (purchase.status == PurchaseStatus.error) {
          locator.loggerService.e('Satın alma hatası: ${purchase.error}');
        }
      }
    });
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: param);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
