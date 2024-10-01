import 'package:cm/widgets/barra_app.dart';
import 'package:cm/widgets/menu_app.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class _LocatorScreenState extends State<LocatorScreen> {
  static final Logger _logger = Logger();

  Future<Position> _refresh() async {
    try {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (LocationPermission.denied == locationPermission ||
          LocationPermission.unableToDetermine == locationPermission) {
        locationPermission = await Geolocator.requestPermission();
      }

      if (LocationPermission.denied == locationPermission ||
          LocationPermission.deniedForever == locationPermission) {
        return Future.error("No hay permiso para acceder a la ubicación");
      }

      // Si llegué acá, si estoy en mi ubicación
      return await Geolocator.getCurrentPosition();
    } catch (error, stackTrace) {
      _logger.e("Ocurrió un error $error", stackTrace: stackTrace);
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraApp(titulo: 'Mi ubicación'),
      drawer: const MenuApp(),
      body: FutureBuilder<Position>(
          future: _refresh(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Position? position = snapshot.data;
              if (position != null) {
                return Center(
                    child: Text("${position.latitude}, ${position.longitude}"));
              } else {
                return const Center(
                    child: Text("No se pudo determinar la ubicación"));
              }
            } else {
              if (snapshot.hasError) {
                _logger.e(snapshot.error);
              }

              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

class LocatorScreen extends StatefulWidget {
  const LocatorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocatorScreenState();
}
