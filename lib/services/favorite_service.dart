// lib/services/favorite_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const _kFavsKey = 'FAVORITE_HOTELS';
  SharedPreferences? _prefs;

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> addFavorite(String hotelId) async {
    await _ensurePrefs();
    final existing = _prefs!.getStringList(_kFavsKey) ?? [];
    if (!existing.contains(hotelId)) {
      existing.add(hotelId);
      await _prefs!.setStringList(_kFavsKey, existing);
    }
  }

  Future<void> removeFavorite(String hotelId) async {
    await _ensurePrefs();
    final existing = _prefs!.getStringList(_kFavsKey) ?? [];
    if (existing.contains(hotelId)) {
      existing.remove(hotelId);
      await _prefs!.setStringList(_kFavsKey, existing);
    }
  }

  Future<List<String>> getFavoriteIds() async {
    await _ensurePrefs();
    return _prefs!.getStringList(_kFavsKey) ?? [];
  }

  Future<bool> isFavorite(String hotelId) async {
    final favs = await getFavoriteIds();
    return favs.contains(hotelId);
  }
}
