// lib/widgets/hotel_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../services/favorite_service.dart';
import '../providers/compare_provider.dart';

/// Otel kartı; JSON’dan gelen model (Hotel) üzerinden tüm verileri gösterir.
class HotelCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onTap,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  late Future<bool> _favFuture;

  @override
  void initState() {
    super.initState();
    // JSON’dan gelen hotel.id’ye göre favori bilgisi sorgulanıyor
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

    // Fiyatı yerel biçimde formatlıyoruz (₺)
    final priceFormatted = NumberFormat.currency(locale: 'tr_TR', symbol: '₺')
        .format(widget.hotel.pricePerNight);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Üstte JSON’dan gelen görsel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                widget.hotel.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,

                // loadingBuilder: resmi yüklerken spinner gösterir
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },

                // frameBuilder: Event hatalarını bastırmaya yardımcı
                frameBuilder: (BuildContext context, Widget child, int? frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  if (frame == null) {
                    // Henüz ilk kare gelmedi: loading spinner göster
                    return SizedBox(
                      height: 160,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  // Kare yüklendi: resmi göster
                  return child;
                },

                // errorBuilder: bir hata olursa kırık resim ikonu göster
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2) Otel ismi, konum ve yıldız (JSON’dan gelen starRating)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.hotel.location,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < widget.hotel.starRating
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.orange.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$priceFormatted / gece',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // 3) Favori ve Karşılaştır butonları (JSON’daki id kullanılıyor)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: _favFuture,
                      builder: (ctx, snapshot) {
                        final isFav = snapshot.data ?? false;
                        return TextButton.icon(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey.shade700,
                          ),
                          label: Text(
                            isFav ? 'Favoriden Çıkar' : 'Favori Ekle',
                            style: TextStyle(
                              color: isFav ? Colors.red : Colors.grey.shade700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          onPressed: _toggleFavorite,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.compare_arrows,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                      label: Text(
                        isSelected ? 'Çıkar' : 'Karşılaştır',
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepPurple.shade700
                            : Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }
}
