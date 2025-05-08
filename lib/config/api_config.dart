// Definir una constante global para la URL de la API
// Hardcodeando directamente la URL correcta
const String API_BASE_URL = 'https://api.insectlab.app';

// URL forzada para todos los entornos
const String FORCED_API_URL = API_BASE_URL;

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    print('Using hardcoded API URL: $FORCED_API_URL');
    return FORCED_API_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
