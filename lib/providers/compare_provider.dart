// lib/providers/compare_provider.dart

import 'package:flutter/material.dart';
import '../models/hotel.dart';

class CompareProvider extends ChangeNotifier {
  final List<Hotel> _selected = [];

  List<Hotel> get selectedHotels => List.unmodifiable(_selected);

  bool isSelected(Hotel hotel) => _selected.any((h) => h.id == hotel.id);

  void toggleCompare(Hotel hotel) {
    if (isSelected(hotel)) {
      _selected.removeWhere((h) => h.id == hotel.id);
    } else {
      if (_selected.length < 2) {
        _selected.add(hotel);
      }
    }
    notifyListeners();
  }

  void clear() {
    _selected.clear();
    notifyListeners();
  }
}
