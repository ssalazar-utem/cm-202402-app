import 'package:cm/screens/error_screen.dart';
import 'package:cm/screens/locator_screen.dart';
import 'package:cm/services/google_service.dart';
import 'package:cm/widgets/barra_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatelessWidget {
  static final Logger _logger = Logger();

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraApp(titulo: 'Página de Login'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título de la pantalla
            Text(
              'Inicio de sesión',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.center, // Alinea el botón al centro
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    GoogleService.logIn().then((result) {
                      if (result) {
                        _logger.i('Me autentiqué super bien');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocatorScreen(),
                          ),
                        );
                      } else {
                        _logger.e('Fui terrible de bueno');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ErrorScreen(),
                          ),
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.g_mobiledata, color: Colors.white), // Icono de Google
                  label: Text(""), // Puedes personalizar el texto si lo deseas
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF403F3F), // Color negro
                    padding: EdgeInsets.symmetric(vertical: 15), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Espacio adicional debajo del botón
            // Campo de Nombre de usuario
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                hintText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo de Contraseña
            TextField(
              obscureText: true, // Oculta el texto
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: '********',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 40), // Espacio extra para separación
            // Botón de Iniciar Sesión
            Align(
              alignment: Alignment.center, // Alinea el botón al centro
              child: SizedBox(
                width: 200, // Ajustar el ancho del botón
                child: ElevatedButton.icon(
                  onPressed: () {
                  },
                  label: Text("Iniciar Sesión", style:TextStyle(color:Colors.white)),
                  icon: Icon(Icons.login, color: Colors.white), // Icono de Google
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF403F3F), // Color negro
                    padding: EdgeInsets.symmetric(vertical: 15), // Tamaño del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),

                ),
              ),
            ),

            SizedBox(height: 20), // Espacio adicional debajo del botón

            // Enlace para registrarse
            TextButton(
              onPressed: () {
                // No se navega cuando se pulsa el texto general, solo en "Regístrate"
              },
              child: RichText(
                text: TextSpan(
                  text: "¿No tienes una cuenta? ",
                  style: TextStyle(color: Colors.black), // Estilo para el texto regular
                  children: <TextSpan>[
                    TextSpan(
                      text: "Regístrate",
                      style: TextStyle(
                        color: Colors.blue, // Color para el texto del enlace
                        decoration: TextDecoration.underline, // Subrayado para el enlace
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Código para ir a registrarse
                          print("Navegar a la pantalla de registro");
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
