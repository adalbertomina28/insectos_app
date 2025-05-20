import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/auth_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl;

  AuthService({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.apiBaseUrl;

  // Iniciar sesión con email y contraseña
  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Registrar un nuevo usuario
  Future<Map<String, dynamic>> signUpWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Iniciar sesión con Google (obtener URL de OAuth)
  Future<String> getGoogleOAuthUrl(String redirectUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/oauth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider': 'google',
          'redirect_url': redirectUrl,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al iniciar OAuth');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Intercambiar código de autenticación por sesión
  Future<Map<String, dynamic>> exchangeCodeForSession(String code) async {
    try {
      // Imprimir información de depuración
      print('Intentando intercambiar código: ${code.substring(0, 5)}...');
      print('URL del backend: $baseUrl/api/auth/exchange-code');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/exchange-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      // Imprimir respuesta para depuración
      print('Código de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body.substring(0, min(100, response.body.length))}...');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result;
      } else if (response.statusCode == 400) {
        // Intentar decodificar el error
        try {
          final error = jsonDecode(response.body);
          print('Error 400: $error');
          throw Exception(error['detail'] ?? 'Error 400 al intercambiar código');
        } catch (decodeError) {
          // Si no podemos decodificar el JSON, devolver un mensaje genérico
          print('Error al decodificar respuesta de error: $decodeError');
          throw Exception('Error 400 al intercambiar código: ${response.body}');
        }
      } else {
        // Para otros códigos de error
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['detail'] ?? 'Error ${response.statusCode} al intercambiar código');
        } catch (decodeError) {
          throw Exception('Error ${response.statusCode} al intercambiar código: ${response.body}');
        }
      }
    } catch (e) {
      // Capturar y registrar cualquier error
      print('Error en exchangeCodeForSession: $e');
      
      // Devolver un mapa con error para que el controlador pueda manejarlo
      return {
        'success': false,
        'error': e.toString(),
        // Proporcionar una sesión simulada para desarrollo si es necesario
        'session': {
          'access_token': 'token_simulado_error',
          'refresh_token': 'refresh_simulado_error',
          'expires_in': 3600,
          'token_type': 'bearer'
        },
        'user': null
      };
    }
  }

  // Cerrar sesión
  Future<void> signOut(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al cerrar sesión');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al restablecer contraseña');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Refrescar token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al refrescar token');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Obtener información del usuario
  Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al obtener usuario');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar metadatos del usuario
  Future<Map<String, dynamic>> updateUserMetadata(String token, Map<String, dynamic> metadata) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/update-metadata'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'metadata': metadata}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al actualizar metadatos');
      }
    } catch (e) {
      rethrow;
    }
  }
}
