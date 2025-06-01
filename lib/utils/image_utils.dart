import 'package:insectos_app/config/api_config.dart';

class ImageUtils {
  /// Convierte una URL directa de Minio a una URL que usa el proxy de imágenes
  /// 
  /// Ejemplo:
  /// http://31.97.11.223:9000/insect-observations/user_id/image.jpg
  /// se convierte en:
  /// http://localhost:8000/api/proxy/image?url=http://31.97.11.223:9000/insect-observations/user_id/image.jpg
  static String getProxiedImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) {
      return '';
    }
    
    // Codificar la URL original para usarla como parámetro de consulta
    final encodedUrl = Uri.encodeComponent(originalUrl);
    
    // Construir la URL del proxy
    return '${ApiConfig.baseUrl}/api/proxy/image?url=$encodedUrl';
  }
}
