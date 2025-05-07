class ApiConfig {
  // Obtener la URL base de la API desde una variable de entorno definida en tiempo de compilación
  // Se define usando --dart-define=API_URL=valor
  static String get baseUrl {
    // Usar String.fromEnvironment para obtener el valor definido en tiempo de compilación
    const apiUrl = 'https://api.insectlab.app';
    
    // Imprimir para depuración
    print('ApiConfig: Usando API URL: $apiUrl');
    
    return apiUrl;
  }

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
