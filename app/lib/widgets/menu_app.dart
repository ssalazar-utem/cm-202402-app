import 'package:cached_network_image/cached_network_image.dart';
import 'package:cm/screens/access_screen.dart';
import 'package:cm/screens/camera_screen.dart';
import 'package:cm/screens/home_screen.dart';
import 'package:cm/screens/locator_screen.dart';
import 'package:cm/services/google_service.dart';
import 'package:cm/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class MenuApp extends StatelessWidget {
  static final Logger _logger = Logger();

  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.orange),
            accountName: FutureBuilder<String>(
              future: StorageService.getValue('name'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final String name = snapshot.data ?? '';
                  return Text(name,
                      style: const TextStyle(color: Colors.black));
                } else {
                  return const Text('Usuario');
                }
              },
            ),
            accountEmail: FutureBuilder<String>(
              future: StorageService.getValue('email'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final String email = snapshot.data ?? '';
                  return Text(email,
                      style: const TextStyle(color: Colors.black));
                } else {
                  return const Text('usuario@gmail.com');
                }
              },
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: FutureBuilder<String>(
                  future: StorageService.getValue('image'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final String photoUrl = snapshot.data ?? '';
                      if (photoUrl.isNotEmpty) {
                        // Caso feliz
                        return CachedNetworkImage(
                          imageUrl: photoUrl,
                          placeholder: (context, url) {
                            return const CircularProgressIndicator();
                          },
                          errorWidget: (context, url, error) {
                            _logger.e(error);
                            return const Icon(Icons.person_3);
                          },
                        );
                      } else {
                        return const Icon(Icons.person_2);
                      }
                    } else if (snapshot.hasError) {
                      // Caso triste
                      _logger
                          .e('No se pudo obtener la información desde Storage');
                      return const Icon(Icons.person);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              _logger.d('Voy a iniciar');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Accesos'),
            onTap: () {
              _logger.d('Voy a la página de accesos');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccessScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Tomar Foto'),
            onTap: () {
              _logger.d('Voy a la página de la camara');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CameraScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Ubicación'),
            onTap: () {
              _logger.d('Voy a la página de ubicación');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocatorScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Salir'),
            onTap: () {
              _logger.d('salgo de la Aplicación');
              GoogleService.logOut();
              SystemNavigator.pop(animated: true);
            },
          )
        ],
      ),
    );
  }
}
