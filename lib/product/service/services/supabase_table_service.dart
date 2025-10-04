import 'dart:math';
import 'package:flutter_supabase_google_odeme/product/service/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// ✅ Kullanıcıları getir (opsiyonel filtre ile)
  Future<List<Map<String, dynamic>>> getUsers({bool? isPremium}) async {
    try {
      var query = _client.from('users').select();
      if (isPremium != null) {
        query = query.eq('is_premium', isPremium);
      }
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      locator.logger.e('Kullanıcılar getirilemedi', error: e);
      return [];
    }
  }

  /// ✅ Tek kullanıcı getir
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      locator.logger.e('Kullanıcı getirilemedi: $userId', error: e);
      return null;
    }
  }

  /// ✅ Kullanıcı ekle
  Future<void> addUser({
    required String id,
    required String email,
    bool isPremium = false,
  }) async {
    try {
      await _client.from('users').insert({
        'id': id,
        'email': email,
        'is_premium': isPremium,
        'premium_last_date': isPremium
            ? DateTime.now().toIso8601String()
            : null,
      });
      locator.logger.i('Kullanıcı eklendi: $email');
    } catch (e) {
      locator.logger.e('Kullanıcı eklenemedi: $email', error: e);
    }
  }

  /// ✅ Random kullanıcı ekle (test amaçlı)
  Future<void> addRandomUser() async {
    final randomId = _generateRandomId();
    final randomEmail = 'user_$randomId@example.com';
    await addUser(id: randomId, email: randomEmail);
  }

  /// ✅ Kullanıcı sil
  Future<void> deleteUser(String userId) async {
    try {
      await _client.from('users').delete().eq('id', userId);
      locator.logger.i('Kullanıcı silindi: $userId');
    } catch (e) {
      locator.logger.e('Kullanıcı silinemedi: $userId', error: e);
    }
  }

  /// ✅ Kullanıcı premium mu?
  Future<bool> isUserPremium(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select('is_premium')
          .eq('id', userId)
          .single();
      return response['is_premium'] ?? false;
    } catch (e) {
      locator.logger.e('Premium durumu kontrol edilemedi: $userId', error: e);
      return false;
    }
  }

  /// ✅ Kullanıcıyı premium yap
  Future<void> markUserPremium(String userId) async {
    try {
      await _client
          .from('users')
          .update({
            'is_premium': true,
            'premium_last_date': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      locator.logger.i('Kullanıcı premium yapıldı: $userId');
    } catch (e) {
      locator.logger.e('Kullanıcı premium yapılamadı: $userId', error: e);
    }
  }

  /// ✅ Kullanıcıyı normal yap (premium kaldır)
  Future<void> removePremium(String userId) async {
    try {
      await _client
          .from('users')
          .update({'is_premium': false, 'premium_last_date': null})
          .eq('id', userId);
      locator.logger.i('Premium kaldırıldı: $userId');
    } catch (e) {
      locator.logger.e('Premium kaldırılamadı: $userId', error: e);
    }
  }

  /// ✅ Tüm kullanıcıları sil (test amaçlı)
  Future<void> clearUsers() async {
    try {
      await _client.from('users').delete().neq('id', ''); // tüm satırları siler
      locator.logger.w('Tüm kullanıcılar silindi!');
    } catch (e) {
      locator.logger.e('Kullanıcılar silinemedi', error: e);
    }
  }

  /// Rastgele UUID benzeri id oluşturur
  String _generateRandomId() {
    final random = Random();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return values.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}
