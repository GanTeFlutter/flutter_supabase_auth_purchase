import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/main.dart';
import 'package:flutter_supabase_google_odeme/product/extension/show_snackbar.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin LoginViewMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;
  bool _redirecting = false;

  final emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  bool get isLoading => _isLoading;

  Future<void> signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signInWithOtp(
        email: emailController.text.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );

      if (mounted) {
        context.showSnackBar('E-postanızı kontrol edin!');
        emailController.clear();
      }
    } on AuthException catch (error) {
      locator.loggerService.e('Auth error: ${error.message}');
      if (mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      locator.loggerService.e('Unexpected error: $error');
      if (mounted) {
        context.showSnackBar('Beklenmeyen bir hata oluştu', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      _onAuthStateChange,
      onError: _onAuthError,
    );
  }

  void _onAuthStateChange(AuthState data) {
    if (_redirecting) return;

    final session = data.session;
    if (session != null) {
      _redirecting = true;
      if (mounted) {
        locator.loggerService.i('Kullanıcı başarıyla giriş yaptı');
        context.showSnackBar('Başarıyla giriş yapıldı!');
        context.goNamed('HomeView');
      }
    }
  }

  void _onAuthError(Object error) {
    if (error is AuthException) {
      locator.loggerService.e('Auth stream error: ${error.message}');
      if (mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } else {
      locator.loggerService.e('Unexpected stream error: $error');
      if (mounted) {
        context.showSnackBar('Beklenmeyen bir hata oluştu', isError: true);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }
}
