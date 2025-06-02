// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/auth/login_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions; // İsteğe bağlı actions

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  Future<void> _logout(BuildContext context) async {
    await AuthService.instance.logout(); // .instance olarak çağır
    Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Çıkış Yap',
          onPressed: () => _logout(context),
        ),
      ],
    );
  }
}
