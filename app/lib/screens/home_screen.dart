import 'package:cm/widgets/barra_app.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: BarraApp(titulo: 'Inicio'),
        body: const Center(child: Text('Estoy dentro')));
  }
}
