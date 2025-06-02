// lib/pages/auth/register_page.dart

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  // Parola gereksinimleri için durum değişkenleri
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  void _checkPassword(String password) {
    setState(() {
      _hasMinLength = password.length >= 6;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasDigit = password.contains(RegExp(r'\d'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#\$&*~^%_\-]'));
    });
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text.trim() != _confirmCtrl.text.trim()) {
      setState(() {
        _error = 'Şifreler uyuşmuyor';
      });
      return;
    }
    if (!(_hasMinLength && _hasUppercase && _hasDigit && _hasSpecialChar)) {
      setState(() {
        _error = 'Parola tüm gereksinimleri karşılamalı';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    try {
      await AuthService.instance.register(email, pass);
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (e) {
      setState(() {
        _error = 'Kayıt sırasında hata oluştu.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Widget _buildRequirementRow(String text, bool satisfied) {
    return Row(
      children: [
        Icon(
          satisfied ? Icons.check_circle : Icons.radio_button_unchecked,
          color: satisfied ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.app_registration,
                      size: 100, color: Colors.deepPurple),
                  const SizedBox(height: 24),
                  Text(
                    'Yeni Hesap Aç',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hemen kaydolun',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-posta',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'E-posta boş olamaz';
                            }
                            if (!val.contains('@')) {
                              return 'Geçerli bir e-posta girin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          onChanged: _checkPassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Şifre boş olamaz';
                            }
                            if (!_hasMinLength ||
                                !_hasUppercase ||
                                !_hasDigit ||
                                !_hasSpecialChar) {
                              return 'Parola gereksinimlerini karşılayın';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        // Parola gereksinimlerini gösteren satırlar
                        _buildRequirementRow('En az 6 karakter', _hasMinLength),
                        _buildRequirementRow(
                            'En az bir büyük harf', _hasUppercase),
                        _buildRequirementRow('En az bir rakam', _hasDigit),
                        _buildRequirementRow(
                            'En az bir özel karakter (!@#\$&*~^%_-)',
                            _hasSpecialChar),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Şifre (Tekrar)',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Şifre tekrar boş olamaz';
                            }
                            if (val.length < 6) {
                              return 'Şifre en az 6 karakter olmalı';
                            }
                            if (val != _passCtrl.text) {
                              return 'Şifreler uyuşmuyor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _doRegister,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text('Kayıt Ol'),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Zaten hesabın var mı? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement<void, void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(
                                  color: Colors.deepPurple.shade700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
