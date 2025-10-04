import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/future/auth/account_view.dart';
import 'package:flutter_supabase_google_odeme/future/auth/login_view.dart';
import 'package:flutter_supabase_google_odeme/future/home/home_view.dart';
import 'package:flutter_supabase_google_odeme/product/init/app_initialize.dart';
import 'package:flutter_supabase_google_odeme/product/init/state_initialize.dart';
import 'package:flutter_supabase_google_odeme/product/theme/app_dark_theme.dart';
import 'package:flutter_supabase_google_odeme/product/theme/app_light_theme.dart';
import 'package:flutter_supabase_google_odeme/future/splash/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'product/navigation/app_gorouter.dart';

Future<void> main() async {
  await AppInitialize().make();
  runApp(const StateInitialize(child: _MyApp()));
}

final supabase = Supabase.instance.client;

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ColorCraftPro',
      theme: AppLightTheme().themeData,
      darkTheme: AppDarkTheme().themeData,
      routerConfig: _router,
    );
  }
}
