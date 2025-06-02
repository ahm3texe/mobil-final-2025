// lib/pages/home/contact_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_app_bar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isSending = false;
  String? _feedback;

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _feedback = null;
    });

    final name = Uri.encodeComponent(_nameCtrl.text.trim());
    final email = Uri.encodeComponent(_emailCtrl.text.trim());
    final message = Uri.encodeComponent(_messageCtrl.text.trim());

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'omerefephlvn@gmail.com',
      query:
          'subject=İletişim Formu - $name&body=İsim: $name\nE-posta: $email\n\nMesaj:\n$message',
    );

    try {
      // Mailto link'i açıyor, e-posta uygulamasını başlatıyor
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        setState(() {
          _feedback = 'E-posta uygulamanız açıldı. Mesajınızı gönderin.';
          _nameCtrl.clear();
          _emailCtrl.clear();
          _messageCtrl.clear();
        });
      } else {
        setState(() {
          _feedback = 'E-posta gönderilemedi. Lütfen tekrar deneyin.';
        });
      }
    } catch (e) {
      setState(() {
        _feedback = 'E-posta gönderilirken hata oluştu.';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _launchEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'omerefephlvn@gmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhoneDialer() async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: '+905551234567',
    );
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'İletişim'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Bize Ulaşın',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Adınız',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Adınızı girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-posta',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'E-posta girin';
                          }
                          if (!val.contains('@')) {
                            return 'Geçerli bir e-posta girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageCtrl,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Mesajınız',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.message_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Mesajınızı yazın';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_feedback != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _feedback!,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 14),
                          ),
                        ),
                      _isSending
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _sendMessage,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text('Gönder'),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Alt kısım: tıklanabilir e-posta ve telefon
                GestureDetector(
                  onTap: _launchEmailClient,
                  child: const Text(
                    'E-posta: omerefephlvn@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _launchPhoneDialer,
                  child: const Text(
                    'Telefon: +90 555 123 45 67',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
