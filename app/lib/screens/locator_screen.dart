import 'package:cm/utils/google_map_utils.dart';
import 'package:cm/widgets/barra_app.dart';
import 'package:cm/widgets/menu_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
                return FlutterMap(
                    options: MapOptions(
                      initialCenter:
                          LatLng(position.latitude, position.longitude),
                      initialZoom: 17.0,
                      onTap: (tapPosition, point) {
                        GoogleMapUtils.openGoogleMap(
                            position.latitude, position.longitude);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'cl.utem.inf.cm',
                      ),
                      MarkerLayer(markers: [
                        Marker(
                            point:
                                LatLng(position.latitude, position.longitude),
                            child: const Icon(Icons.place,
                                color: Colors.red, size: 47.0))
                      ])
                    ]);
              } else {
                return const Center(
                    child: Text("No se pudo determinar la ubicación"));
              }
            } else {
              if (snapshot.hasError) {
                _logger.e(snapshot.error);
              }

              return const Center(child: CircularProgressIndicator());
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
