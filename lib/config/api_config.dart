// Obtener la URL de la API desde las variables de entorno o usar el valor predeterminado
const String apiUrl =
    String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    return apiUrl;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
