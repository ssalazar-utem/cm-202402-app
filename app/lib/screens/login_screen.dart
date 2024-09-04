import 'package:cm/services/google_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página de Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: ElevatedButton(
              onPressed: () {
                GoogleService.logIn().then((result) {
                  if (result) {
                    _logger.i('Me autentiqué super bien');
                  } else {
                    _logger.e('Fui terrible de bueno');
                  }
                });
              },
              child: const Row(
                children: [Icon(Icons.g_mobiledata), Text('Login')],
              )),
        ),
      ),
    );
  }
}
