// lib/pages/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/hotel.dart';
import '../../services/hotel_service.dart';
import '../../widgets/hotel_card.dart'; // Detaylı card
import '../../widgets/hotel_list_card.dart'; // Kompakt card
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import 'hotel_detail_page.dart';
import 'comparison_page.dart';
import '../../providers/compare_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Hotel>> _hotelsFuture;
  bool _isListView = false; // false: detaylı (normal), true: liste

  @override
  void initState() {
    super.initState();
    _hotelsFuture = HotelService().getAllHotels();
  }

  void _toggleViewMode() {
    setState(() {
      _isListView = !_isListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Anasayfa',
        actions: [
          IconButton(
            icon: Icon(
              _isListView ? Icons.view_agenda : Icons.view_list,
              color: Colors.white,
            ),
            tooltip: _isListView ? 'Detaylı Görünüm' : 'Liste Görünümü',
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Hotel>>(
        future: _hotelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Otel bulunamadı.'));
          } else {
            final hotels = snapshot.data!;
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: hotels.length,
                  itemBuilder: (ctx, index) {
                    final hotel = hotels[index];

                    // Liste modu ise kompakt card, değilse detaylı card göster
                    if (_isListView) {
                      return HotelListCard(
                        hotel: hotel,
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => HotelDetailPage(hotel: hotel),
                            ),
                          );
                        },
                      );
                    } else {
                      return HotelCard(
                        hotel: hotel,
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => HotelDetailPage(hotel: hotel),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),

                // Eğer en az 2 otel seçilmişse altta “Karşılaştır” çubuğu göster
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Consumer<CompareProvider>(
                    builder: (context, compareProv, child) {
                      final count = compareProv.selectedHotels.length;
                      if (count < 2) return const SizedBox.shrink();
                      return Container(
                        color: Colors.deepPurple.shade700,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$count otel seçildi',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.deepPurple.shade700,
                              ),
                              onPressed: () {
                                Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const ComparisonPage(),
                                  ),
                                );
                              },
                              child: const Text('Karşılaştır'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
