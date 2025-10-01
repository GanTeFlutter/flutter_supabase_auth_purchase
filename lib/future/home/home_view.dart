import 'package:flutter/material.dart';

import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //

  void fetchUsers(String userId) async {
    final user = await locator.supabase.getUser(userId);
    locator.logger.i('Kullanıcı: $user');
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () {
                fetchUsers('1a9b515f-dba0-2628-1f34-3ffa047fc789');
              },
              child: Text('HomeView'),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('.....................................');
              },
              child: Text('HomeView'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('HomeView')),
            Text('HomeView'),
          ],
        ),
      ),
    );
  }
}
