import 'package:flutter/material.dart';
import 'package:flutter_supabase_google_odeme/main.dart';
import 'package:flutter_supabase_google_odeme/product/extension/show_snackbar.dart';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:go_router/go_router.dart';

mixin AccountMixin<T extends StatefulWidget> on State<T> {
  final usernameController = TextEditingController();
  final userIdController = TextEditingController();

  bool isLoading = false;
  String userID = '';

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    final userId = supabase.auth.currentSession!.user.id;
    final profile = await locator.supabaseService.getProfile(userId);
    if (profile != null) {
      usernameController.text = profile['username'] ?? '';
      userID = profile['id'] ?? '';
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> updateUserData() async {
    locator.loggerService.i('updateUserData çağrıldı');
    setState(() => isLoading = true);
    final userId = supabase.auth.currentSession!.user.id;
    final updates = {
      'id': userId,
      'username': usernameController.text.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    final success = await locator.supabaseService.updateProfile(
      updates: updates,
    );
    locator.loggerService.i('Güncelleme sonucu: $success');
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> signOut() async {
    final success = await locator.supabaseService.signOut();
    if (!mounted) return;
    if (success) {
      context.showSnackBar('Başarıyla çıkış yapıldı.');
      context.goNamed('LoginView');
    } else {
      context.showSnackBar('Çıkış yapılamadı.', isError: true);
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    userIdController.dispose();
    super.dispose();
  }
}
