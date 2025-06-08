import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:insectos_app/config/api_config.dart';
import 'package:insectos_app/controllers/auth_controller.dart';
import 'package:insectos_app/models/observation_model.dart';
import 'package:insectos_app/services/file_upload_service.dart';

class ObservationService extends GetxService {
  final String baseUrl = ApiConfig.baseUrl;
  final _supabase = Supabase.instance.client;
  final FileUploadService _fileUploadService = FileUploadService();

  @override
  void onInit() {
    super.onInit();
  }

  // Obtener catálogo de condiciones
  Future<List<Map<String, dynamic>>> getConditions() async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/catalogs/conditions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Corregir para usar la estructura correcta de la respuesta
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      } else {
        throw Exception('Error al obtener condiciones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getConditions: $e');
      return [];
    }
  }

  // Obtener catálogo de estados
  Future<List<Map<String, dynamic>>> getStates() async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/catalogs/states'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      } else {
        throw Exception('Error al obtener estados: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getStates: $e');
      return [];
    }
  }

  // Obtener catálogo de etapas
  Future<List<Map<String, dynamic>>> getStages() async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/catalogs/stages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      } else {
        throw Exception('Error al obtener etapas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getStages: $e');
      return [];
    }
  }

  // Obtener catálogo de sexos
  Future<List<Map<String, dynamic>>> getSexes() async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/catalogs/sexes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      } else {
        throw Exception('Error al obtener sexos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getSexes: $e');
      return [];
    }
  }

  // Buscar insectos por nombre común
  Future<List<Map<String, dynamic>>> searchInsectsByName(String query) async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/insects/search?query=$query&locale=es&page=1&per_page=10'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> results =
            List<Map<String, dynamic>>.from(data['results'] ?? []);

        // Transformar los resultados al formato esperado por la aplicación
        return results
            .map((insect) => {
                  'id': insect['id'],
                  'scientific_name': insect['name'],
                  'common_name': insect['preferred_common_name'],
                  'inaturalist_id': insect['id'],
                  'photo_url': insect['default_photo']?['medium_url'] ?? ''
                })
            .toList();
      } else {
        throw Exception('Error al buscar insectos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en searchInsectsByName: $e');
      return [];
    }
  }

  // Crear una nueva observación
  Future<Observation?> createObservation({
    required String scientificName,
    required String? commonName,
    required int inaturalistId,
    required DateTime observationDate,
    required double latitude,
    required double longitude,
    required int conditionId,
    required int stateId,
    required int stageId,
    required int sexId,
    String? description,
    List<File> imageFiles = const [],
    List<String>? imageUrls,
  }) async {
    try {
      final AuthController authController = Get.find<AuthController>();
      final String userId = authController.currentUser.value?.id ?? '';
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (userId.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      // Preparar las URLs de las imágenes
      List<String> photoUrls = [];

      // Si tenemos URLs directamente, las usamos
      if (imageUrls != null && imageUrls.isNotEmpty) {
        photoUrls = imageUrls;
      }
      // Si tenemos archivos, los subimos al servidor
      else if (imageFiles.isNotEmpty) {
        photoUrls = await _fileUploadService.uploadImages(imageFiles, userId);

        if (photoUrls.isEmpty) {
          throw Exception('No se pudieron subir las imágenes');
        }
      } else {
        throw Exception('Se requieren imágenes para crear una observación');
      }

      // Convertir las URLs a la estructura que espera el backend
      List<Map<String, dynamic>> photos = [];
      for (int i = 0; i < photoUrls.length; i++) {
        photos.add({
          'photo_url': photoUrls[i],
          'description': null,
          'order': i + 1
        });
      }

      // Preparar los datos de la observación
      final Map<String, dynamic> observationData = {
        'user_id': userId,
        'scientific_name': scientificName,
        'common_name': commonName,
        'inaturalist_id': inaturalistId,
        // Formato YYYY-MM-DD que espera el backend
        'observation_date':
            '${observationDate.year}-${observationDate.month.toString().padLeft(2, '0')}-${observationDate.day.toString().padLeft(2, '0')}',
        'latitude': latitude,
        'longitude': longitude,
        'condition_id': conditionId,
        'state_id': stateId,
        'stage_id': stageId,
        'sex_id': sexId,
        'description': description,
        'photos': photos,
      };

      // Realizar la petición al backend
      final response = await http.post(
        Uri.parse('$baseUrl/api/observations/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(observationData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['observation'] != null) {
          return Observation.fromJson(data['observation']);
        }
      }

      throw Exception('Error al crear la observación: ${response.statusCode}');
    } catch (e) {
      print('Error en createObservation: $e');
      rethrow;
    }
  }

  // Obtener todas las observaciones del usuario actual
  Future<List<Observation>> getUserObservations() async {
    try {
      final AuthController authController = Get.find<AuthController>();
      final String userId = authController.currentUser.value?.id ?? '';
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (userId.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/observations/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['observations'] != null) {
          final List<dynamic> observationsJson = data['observations'];
          print('Observaciones encontradas: ${observationsJson.length}');
          return observationsJson
              .map((json) => Observation.fromJson(json))
              .toList();
        } else {
          print('No se encontraron observaciones en la respuesta');
          return [];
        }
      } else {
        throw Exception(
            'Error al obtener observaciones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getUserObservations: $e');
      return [];
    }
  }

  // Obtener una observación específica por ID
  Future<Observation?> getObservation(String observationId) async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/observations/$observationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['observation'] != null) {
          return Observation.fromJson(data['observation']);
        } else {
          return null;
        }
      } else {
        throw Exception(
            'Error al obtener la observación: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getObservation: $e');
      return null;
    }
  }

  // Eliminar una observación
  Future<bool> deleteObservation(String observationId) async {
    try {
      final String? token = _supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Token de autenticación no disponible');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/observations/$observationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Código 204 No Content significa que la operación fue exitosa
      // pero no hay contenido que devolver
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 200 && response.body.isNotEmpty) {
        // Mantener compatibilidad con versiones anteriores del API
        try {
          final Map<String, dynamic> data = json.decode(response.body);
          return data['success'] == true;
        } catch (e) {
          print('Error al decodificar respuesta: $e');
          return false;
        }
      } else {
        throw Exception(
            'Error al eliminar la observación: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en deleteObservation: $e');
      return false;
    }
  }
}
