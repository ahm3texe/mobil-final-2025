// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kRegisteredEmailKey = 'REGISTERED_EMAIL';
  static const _kRegisteredPasswordKey = 'REGISTERED_PASSWORD';
  static const _kLoggedInEmailKey = 'LOGGED_IN_EMAIL';

  // Singleton yapısı
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// “Dummy” kayıt: e-mail + şifre’yi saklar ve kullanıcıyı oturum açmış sayar
  Future<void> register(String email, String password) async {
    final prefs = await _prefs;
    await prefs.setString(_kRegisteredEmailKey, email);
    await prefs.setString(_kRegisteredPasswordKey, password);
    await prefs.setString(_kLoggedInEmailKey, email);
  }

  /// “Dummy” giriş: kayıtlı email/password ile eşleşiyorsa oturumu açar
  Future<void> login(String email, String password) async {
    final prefs = await _prefs;
    final storedEmail = prefs.getString(_kRegisteredEmailKey);
    final storedPass = prefs.getString(_kRegisteredPasswordKey);

    if (storedEmail == null || storedPass == null) {
      throw Exception('Kayıtlı kullanıcı bulunamadı.');
    }
    if (email != storedEmail || password != storedPass) {
      throw Exception('E-posta veya şifre yanlış.');
    }

    await prefs.setString(_kLoggedInEmailKey, email);
  }

  /// Kayıtlı e-mail’i al, yoksa null döner
  Future<String?> getCurrentUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_kLoggedInEmailKey);
  }

  /// Çıkış: kaydedilen e-mail’i sil
  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_kLoggedInEmailKey);
  }
}
