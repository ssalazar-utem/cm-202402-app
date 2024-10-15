import 'package:camera/camera.dart';
import 'package:cm/widgets/barra_app.dart';
import 'package:cm/widgets/menu_app.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class _CameraScreenState extends State<CameraScreen> {
  static final Logger _logger = Logger();

  late CameraController _controlador;
  late List<CameraDescription> camaras;
  late CameraDescription miCamara;

  Future<void>? _inicializadorControllador;

  Future<void> inicializarCamaras() async {
    try {
      camaras = await availableCameras();
      miCamara = camaras.first;
      _controlador = CameraController(miCamara, ResolutionPreset.max);
      _inicializadorControllador = _controlador.initialize();

      if (mounted) {
        setState(() {
          _logger.i("Vista cargada");
        });
      }
    } catch (error) {
      _logger.e("Error al iniciar camaras", error: error);
    }
  }

  @override
  void initState() {
    super.initState();
    inicializarCamaras();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    try {
      await _inicializadorControllador;
      XFile foto = await _controlador.takePicture();
    } catch (error) {
      _logger.e("Error al tomar foto", error: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MenuApp(),
        appBar: const BarraApp(titulo: 'Tomar foto'),
        body: FutureBuilder<void>(
          future: _inicializadorControllador,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controlador);
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text("Ha ocurrido el siguiente error ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _tomarFoto, child: const Icon(Icons.camera)));
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}
