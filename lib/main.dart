// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ** Supabase için gerekli import: **
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/compare_provider.dart';
import 'services/auth_service.dart';
import 'pages/auth/login_page.dart';
import 'pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Supabase'i initialize et (URL ve anonKey senin projen)
  await Supabase.initialize(
    url: 'https://pemmnakohehpdmtllwdd.supabase.co',
    anonKey:
        'iNr+bnF1AjmyWxdrijvgADEW2JHgZRq6HSIg87VAt8OGIVTD9C2Fa7HkDVIB2CgwfLh9F9p187yDglznWPMAWg==',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompareProvider(),
      child: MaterialApp(
        title: 'Hotel App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: FutureBuilder<String?>(
          future: AuthService.instance.getCurrentUserEmail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final email = snapshot.data;
            if (email == null) {
              return const LoginPage();
            } else {
              return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
