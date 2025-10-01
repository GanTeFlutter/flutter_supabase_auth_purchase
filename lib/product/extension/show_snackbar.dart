import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}

//context.showSnackBar("İşlem başarılı!"); // normal mesaj
//context.showSnackBar("Bir hata oluştu!", isError: true); // hata mesajı
