import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SplashView')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(onPressed: () {}, child: Text('SplashView')),
            ElevatedButton(onPressed: () {}, child: Text('SplashView')),
            ElevatedButton(onPressed: () {}, child: Text('SplashView')),
            Text('SplashView'),
          ],
        ),
      ),
    );
  }
}
