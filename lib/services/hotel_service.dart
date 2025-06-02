// lib/services/hotel_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hotel.dart';

class HotelService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucket = 'hotel-assets';
  // Burada dosya adı oteller.json” olacak şekilde değiştirildi:
  static const String _jsonPath = 'json/oteller.json';

  /// Supabase Storage’dan `hotel-assets/json/oteller.json` dosyasını indirir,
  /// içeriğini parse edip List<Hotel> döner.
  Future<List<Hotel>> getAllHotels() async {
    try {
      // Storage’dan raw Uint8List verisini indir
      Uint8List bytes =
          await _supabase.storage.from(_bucket).download(_jsonPath);

      // Uint8List gelen veriyi String’e çevir
      String jsonString = utf8.decode(bytes);

      // JSON’u decode edip List<Hotel> oluştur
      List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((dynamic e) => Hotel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Hata olursa açıklamalı bir exception fırlat
      throw Exception('Otel verileri yüklenemedi: $e');
    }
  }
}
