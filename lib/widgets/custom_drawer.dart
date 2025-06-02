// lib/widgets/custom_drawer.dart

import 'package:flutter/material.dart';
import '../pages/home/about_page.dart';
import '../pages/home/contact_page.dart';
import '../pages/home/favorites_page.dart';
import '../pages/home/comparison_page.dart'; // Eklendi

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Center(
                child: Text(
                  'versusHotels MENÜ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.deepPurple),
              title: const Text('Anasayfa'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favoriler'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const FavoritesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.compare_arrows, color: Colors.deepPurple),
              title: const Text('Karşılaştırma'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const ComparisonPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text('Hakkımızda'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const AboutPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.grey),
              title: const Text('İletişim'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const ContactPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
