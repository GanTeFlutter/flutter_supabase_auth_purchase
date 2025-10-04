import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('HomeView')),
            ElevatedButton(onPressed: () {}, child: Text('HomeView')),
            ElevatedButton(onPressed: () {}, child: Text('HomeView')),
            Text('HomeView'),
          ],
        ),
      ),
    );
  }
}
