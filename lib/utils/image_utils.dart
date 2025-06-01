import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insectos_app/config/api_config.dart';

/// Clase para almacenar en caché las URLs firmadas con su tiempo de expiración
class _SignedUrlCache {
  final String signedUrl;
  final DateTime expiresAt;

  _SignedUrlCache(this.signedUrl, this.expiresAt);

  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class ImageUtils {
  /// Cache de URLs firmadas para evitar solicitudes repetidas
  static final Map<String, _SignedUrlCache> _signedUrlCache = {};

  /// Obtiene una URL firmada para acceder a una imagen de Minio
  /// 
  /// Ejemplo:
  /// http://31.97.11.223:9000/insect-observations/user_id/image.jpg
  /// se convierte en una URL firmada temporal que permite acceder directamente al objeto
  static Future<String> getSignedImageUrl(String originalUrl) async {
    if (originalUrl.isEmpty) {
      return '';
    }

    // Si no es una URL de Minio, devolverla sin cambios
    if (!originalUrl.contains('minio') && 
        !originalUrl.contains(':9000') && 
        !originalUrl.contains('insect-observations')) {
      return originalUrl;
    }
    
    // Verificar si tenemos una URL firmada válida en caché
    if (_signedUrlCache.containsKey(originalUrl) && 
        _signedUrlCache[originalUrl]!.isValid) {
      return _signedUrlCache[originalUrl]!.signedUrl;
    }
    
    try {
      // Codificar la URL original para usarla como parámetro de consulta
      final encodedUrl = Uri.encodeComponent(originalUrl);
      
      // Construir la URL para obtener la URL firmada
      final url = Uri.parse('${ApiConfig.baseUrl}/api/proxy/signed-url?object_url=$encodedUrl');
      
      // Realizar la solicitud al backend
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final signedUrl = data['signed_url'];
        final expiresIn = data['expires_in'] ?? 3600; // Por defecto: 1 hora
        
        // Calcular el tiempo de expiración
        final expiresAt = DateTime.now().add(Duration(seconds: expiresIn - 60)); // Restar 1 minuto para evitar problemas
        
        // Guardar en caché
        _signedUrlCache[originalUrl] = _SignedUrlCache(signedUrl, expiresAt);
        
        return signedUrl;
      } else {
        // Si hay un error, intentar usar el proxy como fallback
        return getProxiedImageUrl(originalUrl);
      }
    } catch (e) {
      print('Error al obtener URL firmada: $e');
      // Si hay un error, intentar usar el proxy como fallback
      return getProxiedImageUrl(originalUrl);
    }
  }

  /// Método antiguo que usa el proxy de imágenes (se mantiene como fallback)
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
