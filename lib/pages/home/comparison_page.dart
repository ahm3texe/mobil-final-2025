// lib/pages/home/comparison_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/compare_provider.dart';
import '../../models/hotel.dart';
import '../../widgets/custom_app_bar.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compareProv = Provider.of<CompareProvider>(context);
    final selected = compareProv.selectedHotels;

    if (selected.length < 2) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Otel Karşılaştırma'),
        body: const Center(
          child: Text('Karşılaştırmak için 2 otel seçin.'),
        ),
      );
    }

    final Hotel h1 = selected[0];
    final Hotel h2 = selected[1];

    final labels = <String>[
      'Konum',
      'Fiyat/Gece',
      'Oda Türü',
      'Yıldız',
      'Puan',
      'Havuz',
      'Kahvaltı',
      'Wi-Fi',
      'Evcil Hayvan',
    ];

    final values1 = <String>[
      h1.location,
      '₺${h1.pricePerNight.toStringAsFixed(0)}',
      h1.roomType,
      h1.starRating.toString(),
      h1.reviewScore.toString(),
      h1.hasPool ? 'Var' : 'Yok',
      h1.breakfastIncluded ? 'Dahil' : 'Dahil Değil',
      h1.freeWifi ? 'Ücretsiz' : 'Yok',
      h1.petFriendly ? 'Kabul' : 'Reddedildi',
    ];

    final values2 = <String>[
      h2.location,
      '₺${h2.pricePerNight.toStringAsFixed(0)}',
      h2.roomType,
      h2.starRating.toString(),
      h2.reviewScore.toString(),
      h2.hasPool ? 'Var' : 'Yok',
      h2.breakfastIncluded ? 'Dahil' : 'Dahil Değil',
      h2.freeWifi ? 'Ücretsiz' : 'Yok',
      h2.petFriendly ? 'Kabul' : 'Reddedildi',
    ];

    int scoreFeatures(Hotel h) {
      int count = 0;
      if (h.hasPool) count++;
      if (h.breakfastIncluded) count++;
      if (h.freeWifi) count++;
      if (h.petFriendly) count++;
      return count;
    }

    final f1 = scoreFeatures(h1);
    final f2 = scoreFeatures(h2);
    String recommendation;
    if (f1 > f2) {
      recommendation =
          '${h1.name} genel olarak daha fazla özelliğe sahip. Bunu tercih etmeniz daha mantıklı.';
    } else if (f2 > f1) {
      recommendation =
          '${h2.name} genel olarak daha fazla özelliğe sahip. Bunu tercih etmeniz daha mantıklı.';
    } else {
      recommendation =
          'Her iki otelde benzer sayıda özellik mevcut. Bütçe ve konuma göre seçim yapabilirsiniz.';
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Otel Karşılaştırma'),
      body: Column(
        children: [
          // Üstte otel görselleri
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      h1.imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      h2.imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Otel isimleri
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    h1.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    h2.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Karşılaştırma tablosu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(labels.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Etiket
                        Expanded(
                          flex: 2,
                          child: Text(
                            labels[index] + ':',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // H1 değeri
                        Expanded(
                          flex: 3,
                          child: Text(
                            values1[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        // H2 değeri
                        Expanded(
                          flex: 3,
                          child: Text(
                            values2[index],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const Divider(height: 1),
          // Öneri metni
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              recommendation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Seçimi temizle butonu
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                compareProv.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Seçimi Temizle'),
            ),
          ),
        ],
      ),
    );
  }
}
