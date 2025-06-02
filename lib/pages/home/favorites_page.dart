// lib/pages/home/favorites_page.dart

import 'package:flutter/material.dart';

import '../../models/hotel.dart';
import '../../services/favorite_service.dart';
import '../../services/hotel_service.dart';
import '../../widgets/custom_app_bar.dart';
import 'hotel_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Hotel>> _favHotelsFuture;

  @override
  void initState() {
    super.initState();
    _favHotelsFuture = _loadFavorites();
  }

  Future<List<Hotel>> _loadFavorites() async {
    final allHotels = await HotelService().getAllHotels();
    final favIds = await FavoriteService().getFavoriteIds();
    return allHotels.where((h) => favIds.contains(h.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Favoriler'),
      body: FutureBuilder<List<Hotel>>(
        future: _favHotelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz favori eklenmedi.'));
          } else {
            final favs = snapshot.data!;
            return ListView.builder(
              itemCount: favs.length,
              itemBuilder: (ctx, index) {
                final h = favs[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.white,
                  leading: const Icon(Icons.hotel, color: Colors.deepPurple),
                  title: Text(h.name),
                  subtitle: Text(h.location),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.grey, size: 16),
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => HotelDetailPage(hotel: h),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
