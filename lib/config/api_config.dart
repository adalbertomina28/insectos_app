import 'dart:js' as js;

// Definir una constante global para la URL de la API
// Usando la URL completa de Coolify como fallback
const String API_BASE_URL = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://api.insectlab.app');

// URL que se usará realmente, determinada en tiempo de ejecución
String get FORCED_API_URL {
  try {
    // Intentar obtener la URL desde JavaScript (establecida en index.html)
    if (js.context.hasProperty('API_BASE_URL')) {
      final jsUrl = js.context['API_BASE_URL'];
      if (jsUrl != null && jsUrl is String && jsUrl.isNotEmpty) {
        print('Using API URL from JavaScript: $jsUrl');
        return jsUrl;
      }
    }
  } catch (e) {
    print('Error accessing window.API_BASE_URL: $e');
  }
  
  // Si no se puede obtener desde JS, usar el valor de Dart
  print('Using API URL from Dart: $API_BASE_URL');
  return API_BASE_URL;
}

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    return FORCED_API_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
