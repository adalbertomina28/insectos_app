// Definir una constante global para la URL de la API
const String API_BASE_URL = 'https://api.insectlab.app';

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    // Usar la URL hardcodeada sin importar la minificación
    return const String.fromEnvironment('API_BASE_URL', 
      defaultValue: 'https://api.insectlab.app');
  }
  
  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
