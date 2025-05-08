// Obtener la URL de la API desde las variables de entorno o usar el valor predeterminado
const String API_URL = String.fromEnvironment('API_URL', defaultValue: 'https://api.insectlab.app');

// URL base para todos los entornos
const String BACKEND_API_BASE_URL = API_URL;

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    return BACKEND_API_BASE_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
