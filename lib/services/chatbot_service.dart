import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chatbot_model.dart';
import '../config/api_config.dart';

class ChatbotService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<ChatbotResponse> sendQuestion({
    required String question,
    int? insectId,
    String? insectName,
    String language = 'es',
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/chatbot/chat');
      
      final Map<String, dynamic> requestBody = {
        'question': question,
        'language': language,
      };
      
      if (insectId != null) {
        requestBody['insect_id'] = insectId;
      } else if (insectName != null && insectName.isNotEmpty) {
        requestBody['insect_name'] = insectName;
      }
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        // Decodificar la respuesta con UTF-8 para manejar caracteres especiales
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return ChatbotResponse.fromJson(data);
      } else {
        throw Exception('Error al comunicarse con el asistente: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
