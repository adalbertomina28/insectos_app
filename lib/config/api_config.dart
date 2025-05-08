// Definir directamente la URL de la API sin ofuscación
const String BACKEND_API_BASE_URL = 'https://api.insectlab.app';

// URL forzada para todos los entornos
const String FORCED_API_URL = BACKEND_API_BASE_URL;

// Registrar la URL en la inicialización
void _logApiUrl() {
  print('======================================');
  print('==== INICIALIZACIÓN API CONFIG ====');
  print('BACKEND_API_BASE_URL = $BACKEND_API_BASE_URL');
  print('FORCED_API_URL = $FORCED_API_URL');
  print('======================================');
}

// Ejecutar el log inmediatamente
final bool _loggedApiUrl = (() {
  _logApiUrl();
  return true;
})();

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    // Log detallado cada vez que se accede a la URL
    print('======================================');
    print('==== ACCESO A API URL ====');
    print('Retornando URL base de la API: $FORCED_API_URL');
    print('======================================');
    return FORCED_API_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
