import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapUtils {
  static final Logger _logger = Logger();

  GoogleMapUtils._();

  static Future<void> openGoogleMap(double latitud, double longitud) async {
    Uri googleMapUri = Uri.parse(
        'https://www.google.com/maps/?api=1&query=$latitud,$longitud');
    bool ok = await launchUrl(googleMapUri);
    if (!ok) {
      _logger.e("No fue posible redirigir a Google Map");
    }
  }
}
