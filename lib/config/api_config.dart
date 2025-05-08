import 'dart:convert';

// Ofuscar la URL usando codificación Base64 para evitar que Coolify la reemplace
// URL codificada en Base64: 'https://api.insectlab.app'
const String _ENCODED_URL = 'aHR0cHM6Ly9hcGkuaW5zZWN0bGFiLmFwcA==';

// Función para decodificar la URL en tiempo de ejecución
String _buildApiUrl() {
  try {
    // Decodificar la URL desde Base64
    final bytes = base64.decode(_ENCODED_URL);
    final decodedUrl = utf8.decode(bytes);
    print('URL decodificada exitosamente');
    return decodedUrl;
  } catch (e) {
    print('Error al decodificar URL: $e');
    // Fallback en caso de error (usando un método alternativo)
    return String.fromCharCodes([
      104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 
      105, 110, 115, 101, 99, 116, 108, 97, 98, 46, 97, 112, 112
    ]);
  }
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
