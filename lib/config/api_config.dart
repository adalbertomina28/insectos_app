class ApiConfig {
  // Obtener la URL de la API desde las variables de entorno o usar el valor predeterminado
  static const String _devApiUrl = 'http://localhost:8000';
  static const String _prodApiUrl = 'https://insectos-api.coolify.io'; // Actualiza con tu URL de producción
  
  // Retornar la URL base de la API
  static String get apiBaseUrl {
    // Intentar leer de variables de entorno
    final envUrl = const String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Verificar si estamos en modo de producción
    final isProd = const bool.fromEnvironment('PROD_MODE', defaultValue: false);
    if (isProd) {
      return _prodApiUrl;
    }
    
    // Valor por defecto para desarrollo
    return _devApiUrl;
  }
  
  // Mantener compatibilidad con el código existente
  static String get baseUrl => apiBaseUrl;
  
  // Constructor privado para evitar instanciación
  ApiConfig._();
  
  // Headers por defecto para las peticiones HTTP
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Mantener compatibilidad con el código existente
  static Map<String, String> get headers => defaultHeaders;
  
  // Añadir token de autenticación a los headers
  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
