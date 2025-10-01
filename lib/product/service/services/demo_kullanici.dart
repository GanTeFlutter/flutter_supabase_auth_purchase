import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Mevcut fonksiyonlar: isUserPremium, markUserPremium

  /// Random kullanıcı ekler (test amaçlı)
  Future<void> addRandomUser() async {
    try {
      // Rastgele e-mail ve id oluştur
      final randomId = _generateRandomId();
      final randomEmail = 'user_$randomId@example.com';

      final response = await _client.from('users').insert({
        'id': randomId,
        'email': randomEmail,
        'is_premium': false,
        'premium_last_date': null,
      });

      if (response.error != null) {
        print('Hata: ${response.error!.message}');
      } else {
        print('Random kullanıcı eklendi: $randomEmail');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  /// Rastgele UUID benzeri id oluşturur
  String _generateRandomId() {
    final random = Random();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return values.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}
