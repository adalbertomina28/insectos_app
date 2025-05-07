// Definir una constante global para la URL de la API
const String API_BASE_URL = 'https://api.insectlab.app';

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl => API_BASE_URL;
  
  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
