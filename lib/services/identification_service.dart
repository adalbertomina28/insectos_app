import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/identification_result.dart';

class IdentificationService {
  IdentificationService() {
    // Log al crear la instancia del servicio

  }
  final Map<String, String> _headers = ApiConfig.headers;

  Future<IdentificationResult> identifyInsect({
    required File imageFile,
    double? latitude,
    double? longitude,
    String locale = 'es',
  }) async {
    try {
      // Usar la URL de la API desde ApiConfig
      final String baseUrl = ApiConfig.baseUrl;
      final String apiUrl = '$baseUrl/api/identification/identify';
      final uri = Uri.parse(apiUrl);

      // Preparar la solicitud multipart
      var request = http.MultipartRequest('POST', uri);

      // Añadir la imagen como archivo con tipo MIME explícito
      final bytes = await imageFile.readAsBytes();

      // Determinar el tipo MIME basado en la extensión del archivo
      String mimeType = 'image/jpeg';
      if (imageFile.path.toLowerCase().endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imageFile.path.toLowerCase().endsWith('.jpg') ||
          imageFile.path.toLowerCase().endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      }

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      ));

      // Añadir los parámetros opcionales
      if (latitude != null) {
        request.fields['latitude'] = latitude.toString();
      }

      if (longitude != null) {
        request.fields['longitude'] = longitude.toString();
      }

      request.fields['locale'] = locale;

      // Añadir headers
      _headers.forEach((key, value) {
        request.headers[key] = value;
      });

      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        return IdentificationResult.fromJson(decodedResponse);
      } else {
        throw Exception(
            'Error al identificar la imagen: ${response.statusCode}. Respuesta: ${response.body}');
      }
    } catch (e) {

      throw Exception('Error de conexión: $e');
    }
  }
}
