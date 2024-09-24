import 'package:cm/models/access.dart';
import 'package:cm/services/rest_service.dart';
import 'package:cm/widgets/barra_app.dart';
import 'package:cm/widgets/menu_app.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BarraApp(titulo: 'Inicio'),
        drawer: const MenuApp(),
        body: Center(
            child: FloatingActionButton(
                onPressed: () {
                  Future<List<Access>> future = RestService.access();
                  future.whenComplete(() {
                    _logger.d("Terminé");
                  });
                },
                child: const Text('Estoy dentro'))));
  }
}
