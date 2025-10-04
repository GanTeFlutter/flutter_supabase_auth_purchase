import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';

import 'package:flutter_supabase_google_odeme/product/state/cubit/auth_cubit.dart';
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
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is AuthSuccess) {
            if (state.loggedIn) {
              locator.logger.i(
                'Kullanıcı giriş yapmış AccountPage yönlendiriliyor',
              );
              context.goNamed('AccountPage');
            } else {
              locator.logger.i(
                'Kullanıcı giriş yapmamış LoginPage yönlendiriliyor',
              );
              context.goNamed('LoginPage');
            }
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
