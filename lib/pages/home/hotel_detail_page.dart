// lib/pages/home/hotel_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/hotel.dart';
import '../../services/favorite_service.dart';
import '../../providers/compare_provider.dart';
import '../../widgets/custom_app_bar.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailPage({super.key, required this.hotel});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  late Future<bool> _favFuture;

  @override
  void initState() {
    super.initState();
    _favFuture = FavoriteService().isFavorite(widget.hotel.id);
  }

  Future<void> _toggleFavorite() async {
    final isFav = await FavoriteService().isFavorite(widget.hotel.id);
    if (isFav) {
      await FavoriteService().removeFavorite(widget.hotel.id);
    } else {
      await FavoriteService().addFavorite(widget.hotel.id);
    }
    setState(() {
      _favFuture = FavoriteService().isFavorite(widget.hotel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final compareProv = Provider.of<CompareProvider>(context);
    final isSelected = compareProv.isSelected(widget.hotel);

    final priceFormatted = NumberFormat.currency(locale: 'tr_TR', symbol: '₺')
        .format(widget.hotel.pricePerNight);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Otel Detayı'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Üstte büyük görsel
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Image.network(
                widget.hotel.imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) {
                  return Container(
                    height: 240,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 64, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // 2) Bilgiler kartı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Otel adı
                      Text(
                        widget.hotel.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Konum
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.hotel.location,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Yıldız puanı
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < widget.hotel.starRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 20,
                            color: Colors.orange.shade400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Fiyat
                      Text(
                        priceFormatted + ' / gece',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Diğer kriterler
                      _infoRow(
                          Icons.king_bed, 'Oda Türü', widget.hotel.roomType),
                      const SizedBox(height: 16),
                      _infoRow(Icons.star, 'Puan',
                          widget.hotel.reviewScore.toString()),
                      const SizedBox(height: 16),
                      _infoRow(Icons.pool, 'Havuz',
                          widget.hotel.hasPool ? 'Var' : 'Yok'),
                      const SizedBox(height: 16),
                      _infoRow(Icons.free_breakfast, 'Kahvaltı',
                          widget.hotel.breakfastIncluded ? 'Dahil' : 'Değil'),
                      const SizedBox(height: 16),
                      _infoRow(Icons.wifi, 'Wi-Fi',
                          widget.hotel.freeWifi ? 'Ücretsiz' : 'Yok'),
                      const SizedBox(height: 16),
                      _infoRow(Icons.pets, 'Evcil Hayvan',
                          widget.hotel.petFriendly ? 'Kabul' : 'Reddedildi'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 3) Favori ve Karşılaştır butonları (büyük)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: _favFuture,
                      builder: (ctx, snapshot) {
                        final isFav = snapshot.data ?? false;
                        return ElevatedButton.icon(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                          ),
                          label: Text(
                            isFav ? 'Favoriden Çıkar' : 'Favori Ekle',
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav
                                ? Colors.red.shade600
                                : Colors.grey.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _toggleFavorite,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.compare_arrows,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      label: Text(
                        isSelected ? 'Çıkar' : 'Karşılaştır',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepPurple.shade700
                            : Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        compareProv.toggleCompare(widget.hotel);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.deepPurple.shade700),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
