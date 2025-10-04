import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';

import 'package:flutter_supabase_google_odeme/product/state/cubit/splash_auth_cubit.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashAuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashAuthCubit, SplashAuthState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is SplashAuthSuccess) {
            if (state.loggedIn) {
              locator.loggerService.i(
                'Kullanıcı giriş yapmış HomeView yönlendiriliyor',
              );
              context.goNamed('HomeView');
            } else {
              locator.loggerService.i(
                'Kullanıcı giriş yapmamış LoginPage yönlendiriliyor',
              );
              context.goNamed('LoginView');
            }
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
