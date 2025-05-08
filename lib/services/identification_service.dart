import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/identification_result.dart';

class IdentificationService {
  // URL directa sin ofuscación
  final String _baseUrl = 'https://api.insectlab.app';

  IdentificationService() {
    // Log al crear la instancia del servicio
    developer.log(
        'SERVICIO: IdentificationService creado con URL base: $_baseUrl',
        name: 'identification_service');
  }
  final Map<String, String> _headers = ApiConfig.headers;

  Future<IdentificationResult> identifyInsect({
    required File imageFile,
    double? latitude,
    double? longitude,
    String locale = 'es',
  }) async {
    try {
      // Crear una solicitud multipart y registrar la URL
      final uriString = '$_baseUrl/api/identification/identify';
      developer.log(
          'SOLICITUD: Construyendo URL para identificación: $uriString',
          name: 'identification_service');
      final uri = Uri.parse(uriString);

      // Preparar la solicitud multipart
      var request = http.MultipartRequest('POST', uri);

      // Añadir la imagen como archivo con tipo MIME explícito
      final bytes = await imageFile.readAsBytes();
      print('Tamaño de la imagen: ${bytes.length} bytes');
      print('Ruta de la imagen: ${imageFile.path}');

      // Determinar el tipo MIME basado en la extensión del archivo
      String mimeType = 'image/jpeg';
      if (imageFile.path.toLowerCase().endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imageFile.path.toLowerCase().endsWith('.jpg') ||
          imageFile.path.toLowerCase().endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      }
      print('Tipo MIME detectado: $mimeType');

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
      developer.log('SOLICITUD: Enviando solicitud de identificación a: $uri',
          name: 'identification_service');
      print('Usando URL: $_baseUrl');
      print('Enviando solicitud de identificación a: $uri');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Respuesta exitosa (200)');
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        // Mostrar un fragmento de la respuesta para depuración
        print(
            'Contenido de la respuesta: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

        return IdentificationResult.fromJson(decodedResponse);
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        throw Exception(
            'Error al identificar la imagen: ${response.statusCode}. Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
