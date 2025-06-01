import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:insectos_app/config/api_config.dart';

class FileUploadService {
  final String baseUrl = ApiConfig.baseUrl;

  // Subir una imagen al servidor
  Future<String?> uploadImage(dynamic file, String userId) async {
    try {
      // Imprimir para depuración
      print('Iniciando carga de imagen con tipo: ${file.runtimeType}');
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/storage/upload-image'),
      );

      Uint8List bytes;
      String filename;

      if (kIsWeb) {
        // Para web
        try {
          if (file is Map<String, dynamic>) {
            // Si es un mapa con bytes y nombre (lo esperado en web)
            bytes = file['bytes'] is Uint8List
                ? file['bytes'] as Uint8List
                : Uint8List.fromList((file['bytes'] as List<int>));
            filename = file['name'] ?? 'web_image.jpg';
          } else if (file is XFile) {
            // Manejar XFile directamente
            bytes = await file.readAsBytes();
            filename = file.name;
          } else {
            throw Exception('Tipo de archivo no soportado en web: ${file.runtimeType}');
          }
        } catch (e, stackTrace) {
          print('Error al procesar archivo en web: $e');
          print('Stack trace: $stackTrace');
          rethrow;
        }
      } else {
        // Para móvil/desktop
        if (file is File) {
          bytes = await file.readAsBytes();
          filename = path.basename(file.path);
        } else if (file is XFile) {
          bytes = await file.readAsBytes();
          filename = file.name;
        } else {
          throw Exception('Tipo de archivo no soportado en móvil: ${file.runtimeType}');
        }
      }

      // Determinar el tipo de contenido basado en la extensión del archivo
      String extension = path.extension(filename).toLowerCase();
      MediaType contentType;
      
      if (extension == '.png') {
        contentType = MediaType('image', 'png');
      } else if (extension == '.gif') {
        contentType = MediaType('image', 'gif');
      } else {
        // Por defecto asumimos JPEG
        contentType = MediaType('image', 'jpeg');
      }
      
      // Agregar el archivo
      final multipartFile = http.MultipartFile.fromBytes(
        'file',  // Nombre del campo que espera el backend
        bytes,
        filename: filename,
        contentType: contentType,
      );

      request.files.add(multipartFile);
      
      // Imprimir para depuración
      print('Archivo agregado a la solicitud: ${filename} (${bytes.length} bytes)');
      print('Files en request: ${request.files.length}');

      // Agregar los campos que espera el backend
      // El backend espera el user_id en el campo path
      request.fields['path'] = userId;
      
      // Imprimir para depuración
      print('Campos en request: ${request.fields}');

      // Imprimir para depuración
      print('Enviando solicitud a: ${request.url}');
      
      // Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // Imprimir para depuración
      print('Respuesta del servidor: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // La respuesta tiene la URL en 'image_url' en lugar de 'url'
        final imageUrl = data['image_url'];
        print('URL de la imagen: $imageUrl');
        return imageUrl;
      } else {
        print(
            'Error en uploadImage: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en uploadImage: $e');
      rethrow; // Relanzar el error para manejarlo en el llamador
    }
  }

  // Subir múltiples imágenes
  Future<List<String>> uploadImages(
      List<dynamic> imageFiles, String userId) async {
    List<String> urls = [];

    for (var imageFile in imageFiles) {
      try {
        final url = await uploadImage(imageFile, userId);
        if (url != null) {
          urls.add(url);
        }
      } catch (e) {
        print('Error al subir imagen: $e');
        // Continuar con las siguientes imágenes aunque falle una
      }
    }

    return urls;
  }
}
