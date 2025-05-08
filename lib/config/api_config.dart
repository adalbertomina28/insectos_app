import 'dart:js' as js;

// Definir una constante global para la URL de la API
const String API_BASE_URL = 'https://api.insectlab.app';

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    // Intentar obtener la URL desde la variable window.API_BASE_URL definida en index.html
    try {
      if (js.context.hasProperty('API_BASE_URL')) {
        final jsUrl = js.context['API_BASE_URL'];
        if (jsUrl != null && jsUrl is String && jsUrl.isNotEmpty) {
          print('Using API URL from window.API_BASE_URL: $jsUrl');
          return jsUrl;
        }
      }
    } catch (e) {
      print('Error accessing window.API_BASE_URL: $e');
    }
    
    // Si no se puede obtener desde JS, usar la URL hardcodeada
    final envUrl = const String.fromEnvironment('API_BASE_URL', 
      defaultValue: 'https://api.insectlab.app');
    print('Using API URL from dart-define: $envUrl');
    return envUrl;
  }
  
  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
