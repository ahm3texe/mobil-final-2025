// lib/pages/home/about_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_app_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  /// Takım üyeleri için Supabase dosya adı, görüntülenecek ad, rol ve açıklama bilgisi:
  final List<Map<String, String>> _teamMembers = const [
    {
      'filename': 'omer.jpeg',
      'name': 'Ömer Faruk Pehlivan',
      'role': 'Flutter Geliştirici',
      'description':
          'Mobil uygulamaların UI/UX akışlarını tasarlar ve kodlarını yazar.',
    },
    {
      'filename': 'ogun.jpeg',
      'name': 'Ogün Şahin',
      'role': 'UI/UX Tasarımcısı',
      'description':
          'Kullanıcı deneyimini odak noktasına alarak ekran tasarımlarını oluşturur.',
    },
    {
      'filename': 'ahmet.jpeg',
      'name': 'Ahmet Şafak Yıldırım',
      'role': 'Backend Geliştirici',
      'description':
          'Sunucu tarafı mantığını yazar, veritabanı ve API entegrasyonlarını yapar.',
    },
  ];

  late Future<List<_AvatarData>> _avatarsFuture;

  @override
  void initState() {
    super.initState();
    _avatarsFuture = _fetchAvatarsFromSupabase();
  }

  Future<List<_AvatarData>> _fetchAvatarsFromSupabase() async {
    final supabase = Supabase.instance.client;
    const String bucket = 'hotel-assets';
    const String folderPath = 'images/avatar';

    List<_AvatarData> results = [];
    for (var member in _teamMembers) {
      final fileName = member['filename']!;
      final name = member['name']!;
      final role = member['role']!;
      final description = member['description']!;

      // Supabase Storage’dan public URL oluştur
      final url =
          supabase.storage.from(bucket).getPublicUrl('$folderPath/$fileName');

      if (url.isEmpty) {
        throw Exception('Public URL alınamadı: $fileName');
      }

      results.add(_AvatarData(
        name: name,
        role: role,
        description: description,
        imageUrl: url,
      ));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Hakkımızda'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biz Kimiz?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'VersusHotels ekibi, seyahat ve teknoloji tutkunu '
              'geliştiricilerden ve tasarımcılardan oluşur. '
              'Amacımız; kullanıcıların kolay, hızlı ve keyifli bir '
              'seyahat planlama deneyimi yaşamasını sağlayacak çözümler üretmektir.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Personellerimiz:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Personelleri alt alta listeleyecek ListView
            Expanded(
              child: FutureBuilder<List<_AvatarData>>(
                future: _avatarsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Avatarlarda hata: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final avatars = snapshot.data ?? [];
                  if (avatars.isEmpty) {
                    return const Center(
                        child: Text('Henüz personel bulunamadı.'));
                  }

                  return ListView.separated(
                    itemCount: avatars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final avatar = avatars[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: NetworkImage(avatar.imageUrl),
                                onBackgroundImageError: (_, __) =>
                                    const Icon(Icons.person, size: 40),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      avatar.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      avatar.role,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      avatar.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Personel verilerini tutan model sınıfı
class _AvatarData {
  final String name;
  final String role;
  final String description;
  final String imageUrl;

  _AvatarData({
    required this.name,
    required this.role,
    required this.description,
    required this.imageUrl,
  });
}
