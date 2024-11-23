import 'dart:convert';
import 'package:http/http.dart' as http;

class INaturalistService {
  static const String _baseUrl = 'https://api.inaturalist.org/v1';
  static const Map<String, String> _headers = {
    'User-Agent': 'Insectos-App/1.0 (Educational App; contact@insectosapp.com)',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> searchInsects({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/taxa?q=$query&page=$page&per_page=$perPage&iconic_taxa=Insecta',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 429) {
        throw Exception('Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {
        throw Exception('Error al buscar insectos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> getInsectDetails(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/taxa/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0];
        }
        throw Exception('No se encontraron detalles del insecto');
      } else if (response.statusCode == 429) {
        throw Exception('Se ha excedido el límite de solicitudes. Por favor, intenta más tarde.');
      } else {
        throw Exception('Error al obtener detalles del insecto');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
