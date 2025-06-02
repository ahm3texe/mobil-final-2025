// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  /// Yeni kullanıcı kaydı: Mevcut user listesine UserModel ekleyip kaydeder
  Future<void> registerUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    // 1) Mevcut kayıtlı kullanıcıları oku
    final usersJson = prefs.getStringList('users') ?? <String>[];

    // 2) Birden fazla kullanıcı olabilir; email benzersiz olmalı
    for (final uJson in usersJson) {
      final map = json.decode(uJson) as Map<String, dynamic>;
      if (map['email'] == user.email) {
        throw Exception('Bu e-posta zaten kayıtlı.');
      }
    }

    // 3) Yeni kullanıcıyı listeye ekle
    usersJson.add(json.encode(user.toMap()));
    await prefs.setStringList('users', usersJson);
  }

  /// Email & şifre kontrol ederek giriş yapar, eğer başarılıysa currentUserEmail kaydeder
  Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? <String>[];

    // 1) Kayıtlı kullanıcılar içinde eşleşen email ve şifre var mı?
    for (final uJson in usersJson) {
      final map = json.decode(uJson) as Map<String, dynamic>;
      if (map['email'] == email && map['password'] == password) {
        // Giriş başarılı: current_user_email’i kaydet
        await prefs.setString('current_user_email', email);
        return true;
      }
    }
    return false; // Bulunamadı → giriş başarısız
  }

  /// Mevcut oturum açmış kullanıcı e-postasını döner (null ise oturum yok)
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_email');
  }

  /// Çıkış: current_user_email’i kaldır
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_email');
  }

  /// Uygulamada oturum açmış kullanıcının UserModel verisini döner (null ise oturum yok)
  Future<UserModel?> getCurrentUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user_email');
    if (email == null) return null;

    final usersJson = prefs.getStringList('users') ?? <String>[];
    for (final uJson in usersJson) {
      final map = json.decode(uJson) as Map<String, dynamic>;
      if (map['email'] == email) {
        return UserModel.fromMap(map);
      }
    }
    return null;
  }

  /// Profil güncelleme: mevcut kullanıcıyı bul, liste içindeki o kaydı güncelle
  Future<void> updateCurrentUser(UserModel updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList('users') ?? <String>[];
    final List<String> newList = [];

    for (final uJson in usersJson) {
      final map = json.decode(uJson) as Map<String, dynamic>;
      if (map['email'] == updatedUser.email) {
        // Bu user bizim güncellenecek kullanıcı → yeni verileri ekle
        newList.add(json.encode(updatedUser.toMap()));
      } else {
        newList.add(uJson);
      }
    }

    await prefs.setStringList('users', newList);
  }
}
