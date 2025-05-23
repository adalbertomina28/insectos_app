import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:insectos_app/config/api_config.dart';
import 'package:insectos_app/controllers/auth_controller.dart';
import 'package:insectos_app/models/observation_model.dart';

class ObservationService {
  final String baseUrl = ApiConfig.baseUrl;
  final _supabase = Supabase.instance.client;
  
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
        
        if (data['success'] == true && data['observations'] != null) {
          final List<dynamic> observationsJson = data['observations'];
          return observationsJson.map((json) => Observation.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Error al obtener observaciones: ${response.statusCode}');
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
        throw Exception('Error al obtener la observación: ${response.statusCode}');
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
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      } else {
        throw Exception('Error al eliminar la observación: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en deleteObservation: $e');
      return false;
    }
  }
}
