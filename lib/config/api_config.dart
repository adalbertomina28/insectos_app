import 'dart:html' as html;

class ApiConfig {
  // Obtener la URL base de la API desde una variable de entorno
  // Si no está definida, usar un valor por defecto
  static String get baseUrl {
    // Intentar obtener la URL desde la variable de entorno
    final envUrl = html.window.document.documentElement?.dataset['searchApiUrl'];
    
    // Valores por defecto según el entorno
    return envUrl ?? 'https://api.insectlab.app'; // URL por defecto si no hay variable de entorno
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
