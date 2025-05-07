import 'dart:html' as html;

class ApiConfig {
  // Obtener la URL base de la API desde una variable de entorno
  // Si no está definida, usar un valor por defecto
  static String get baseUrl {
    // Intentar obtener la URL desde la variable de entorno
    final envUrl = html.window.document.documentElement?.dataset['searchApiUrl'];
    
    // Imprimir para depuración
    print('ApiConfig: URL obtenida del dataset: $envUrl');
    
    // Si la URL está vacía o es nula, usar el valor predeterminado
    if (envUrl == null || envUrl.isEmpty || envUrl == '__SEARCH_API_URL__') {
      print('ApiConfig: Usando URL predeterminada');
      return 'https://api.insectlab.app';
    }
    
    print('ApiConfig: Usando URL del entorno: $envUrl');
    return envUrl;
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
