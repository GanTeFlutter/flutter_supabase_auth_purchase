import 'dart:math';
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
      print('Hata (getUsers): $e');
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
      print('Hata (getUser): $e');
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
      print('Kullanıcı eklendi: $email');
    } catch (e) {
      print('Hata (addUser): $e');
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
      print('Kullanıcı silindi: $userId');
    } catch (e) {
      print('Hata (deleteUser): $e');
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
      print('Hata (isUserPremium): $e');
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
      print('Kullanıcı premium yapıldı!');
    } catch (e) {
      print('Hata (markUserPremium): $e');
    }
  }

  /// ✅ Kullanıcıyı normal yap (premium kaldır)
  Future<void> removePremium(String userId) async {
    try {
      await _client
          .from('users')
          .update({'is_premium': false, 'premium_last_date': null})
          .eq('id', userId);
      print('Kullanıcı premium kaldırıldı!');
    } catch (e) {
      print('Hata (removePremium): $e');
    }
  }

  /// ✅ Tüm kullanıcıları sil (test amaçlı)
  Future<void> clearUsers() async {
    try {
      await _client.from('users').delete().neq('id', ''); // tüm satırları siler
      print('Tüm kullanıcılar silindi!');
    } catch (e) {
      print('Hata (clearUsers): $e');
    }
  }

  /// Rastgele UUID benzeri id oluşturur
  String _generateRandomId() {
    final random = Random();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return values.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
  }
}
