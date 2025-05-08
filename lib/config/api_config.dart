// Definir una constante global para la URL de la API
const String API_BASE_URL = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://t0gsggssgg8ow04ocwww08oo.195.35.36.123.sslip.io');
// URL forzada para todos los entornos
const String FORCED_API_URL = API_BASE_URL;

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    // SIEMPRE usar la URL forzada para evitar problemas con Coolify
    print('Using forced API URL: $FORCED_API_URL');
    return FORCED_API_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
