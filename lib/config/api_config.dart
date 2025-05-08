// Ofuscar la URL dividiéndola en partes para evitar que Coolify la reemplace
// Parte 1 de la URL
const String _URL_PART1 = 'https://a';
// Parte 2 de la URL
const String _URL_PART2 = 'pi.insect';
// Parte 3 de la URL
const String _URL_PART3 = 'lab.app';

// Función para construir la URL en tiempo de ejecución
String _buildApiUrl() {
  // Construir la URL concatenando las partes
  return _URL_PART1 + _URL_PART2 + _URL_PART3;
}

// Definir una constante global para la URL de la API
// Usando una función para construir la URL
final String API_BASE_URL = _buildApiUrl();

// URL forzada para todos los entornos
final String FORCED_API_URL = API_BASE_URL;

class ApiConfig {
  // Retornar la URL base de la API
  static String get baseUrl {
    print('Using obfuscated API URL: $FORCED_API_URL');
    return FORCED_API_URL;
  }

  // Constructor privado para evitar instanciación
  ApiConfig._();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
