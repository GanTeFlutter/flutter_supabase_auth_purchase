import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

mixin PurchasingViewMixin<T extends StatefulWidget> on State<T> {
  final _purchasingService = locator.purchasingService;
  List<ProductDetails> get products => _purchasingService.products;
  bool get isAvailable => _purchasingService.isAvailable;

  @override
  void initState() {
    super.initState();
    _initializePurchasing();
  }

  Future<void> _initializePurchasing() async {
    await _purchasingService.initialize();
    _purchasingService.startListeningToPurchases(_handlePurchaseUpdate);
    setState(() {});
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    onPurchaseUpdate(purchases);
  }

  Future<void> buyProduct(ProductDetails product) async {
    await _purchasingService.buyProduct(product);
    
  }

  @override
  void dispose() {
    _purchasingService.dispose();
    super.dispose();
  }

  void onPurchaseUpdate(List<PurchaseDetails> purchases) {}
}
