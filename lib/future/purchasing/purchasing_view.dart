import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/purchasing/mixin/purchasing_view_mixin.dart';

class PurchasingView extends StatefulWidget {
  const PurchasingView({super.key});

  @override
  State<PurchasingView> createState() => _PurchasingViewState();
}

class _PurchasingViewState extends State<PurchasingView>
    with PurchasingViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PurchasingView')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('PurchasingView')),
            ElevatedButton(onPressed: () {}, child: Text('PurchasingView')),
            ElevatedButton(onPressed: () {}, child: Text('PurchasingView')),
            Text('PurchasingView'),
          ],
        ),
      ),
    );
  }
}
