import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/home/mixin/home_view_mixin.dart';
import 'package:go_router/go_router.dart';
part 'widget/home_appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _HomeAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            IconButton(
              onPressed: () {
                context.goNamed('AccountView');
              },
              icon: Icon(Icons.person_2_outlined),
            ),
            IconButton(
              onPressed: () {
                context.goNamed('PurchaseView');
              },
              icon: Icon(Icons.shopping_cart_outlined),
            ),
            IconButton(
              onPressed: () {
                context.goNamed('DatabaseView');
              },
              icon: Icon(Icons.storage_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
