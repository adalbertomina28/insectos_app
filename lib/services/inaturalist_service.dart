import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/insect_model.dart';

class InsectService {
  InsectService() {}
  final Map<String, String> _headers = ApiConfig.headers;

  Future<Map<String, dynamic>> searchInsects({
    required String query,
    String locale = 'es',
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Usar la URL de la API desde ApiConfig
      final String apiBase = ApiConfig.baseUrl;
      final String endpoint = '$apiBase/api/insects/search';
      final uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'query': query,
          'locale': locale,
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        
        // Verificar si hay resultados
        if (decodedResponse['results'] != null &&
            decodedResponse['results'].isNotEmpty) {
          // Procesar resultados
        }
        return decodedResponse;
      } else if (response.statusCode == 429) {

        throw Exception(
            'Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {

        throw Exception(
            'Error al buscar insectos: ${response.statusCode}. Respuesta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> getInsectDetails(int id,
      {String locale = 'es'}) async {
    try {
      // Usar la URL de la API desde ApiConfig
      final String apiBase = ApiConfig.baseUrl;
      final String endpoint = '$apiBase/api/insects/$id';
      final uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'locale': locale,
        },
      );

      final response = await http.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 429) {
        throw Exception(
            'Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {
        throw Exception('Error al obtener detalles del insecto');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> getNearbyInsects({
    required double latitude,
    required double longitude,
    int radius = 50,
    String locale = 'es',
  }) async {
    try {
      // Usar la URL de la API desde ApiConfig
      final String apiBase = ApiConfig.baseUrl;
      final String endpoint = '$apiBase/api/insects/nearby';
      final uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lng': longitude.toString(),
          'radius': radius.toString(),
          'locale': locale,
        },
      );

      final response = await http.get(
        uri,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 429) {
        throw Exception(
            'Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {
        throw Exception('Error al obtener insectos cercanos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
