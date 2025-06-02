// lib/widgets/hotel_list_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../services/favorite_service.dart';
import '../providers/compare_provider.dart';

/// Kısa, tek satırlık otel kartı; JSON’dan gelen verileri kullanır.
class HotelListCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback onTap;

  const HotelListCard({
    super.key,
    required this.hotel,
    required this.onTap,
  });

  @override
  State<HotelListCard> createState() => _HotelListCardState();
}

class _HotelListCardState extends State<HotelListCard> {
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

    return ListTile(
      onTap: widget.onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.hotel.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
          ),
        ),
      ),
      title: Text(
        widget.hotel.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.hotel.location),
      trailing: SizedBox(
        width: 96,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<bool>(
              future: _favFuture,
              builder: (ctx, snapshot) {
                final isFav = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey.shade700,
                  ),
                  onPressed: _toggleFavorite,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.compare_arrows,
                color: isSelected
                    ? Colors.deepPurple.shade700
                    : Colors.grey.shade700,
              ),
              onPressed: () {
                compareProv.toggleCompare(widget.hotel);
              },
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      dense: true,
    );
  }
}
