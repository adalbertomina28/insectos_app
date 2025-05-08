import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/insect_model.dart';

class InsectService {
  // URL directa sin ofuscación
  final String _baseUrl = 'http://api.insectlab.app';
  final Map<String, String> _headers = ApiConfig.headers;

  Future<Map<String, dynamic>> searchInsects({
    required String query,
    String locale = 'es',
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Construir la URL de forma dinámica
      final uri = Uri.parse(_baseUrl).replace(
        path: '/api/insects/search',
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

      print('Realizando petición a: ${uri.toString()}');
      print('Headers: $_headers');

      if (response.statusCode == 200) {
        print('Respuesta exitosa (200)');
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        print(
            'Contenido de la respuesta: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

        if (decodedResponse['results'] != null &&
            decodedResponse['results'].isNotEmpty) {
          final firstResult = decodedResponse['results'][0];
          print(
              'Primer resultado: ${firstResult.toString().substring(0, firstResult.toString().length > 100 ? 100 : firstResult.toString().length)}...');
        } else {
          print(
              'No se encontraron resultados o la estructura es diferente a la esperada');
          print('Estructura de respuesta: ${decodedResponse.keys.toString()}');
        }
        return decodedResponse;
      } else if (response.statusCode == 429) {
        print('Error 429: Límite de solicitudes excedido');
        throw Exception(
            'Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {
        print('Error ${response.statusCode}: ${response.body}');
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
      final uri = Uri.parse(_baseUrl).replace(
        path: '/api/insects/$id',
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
      final uri = Uri.parse(_baseUrl).replace(
        path: '/api/insects/nearby',
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
