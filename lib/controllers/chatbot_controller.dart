import 'package:get/get.dart';
import '../models/chatbot_model.dart';
import '../services/chatbot_service.dart';
import '../controllers/language_controller.dart';

class ChatbotController extends GetxController {
  final ChatbotService _chatbotService = ChatbotService();
  final LanguageController _languageController = Get.find<LanguageController>();
  
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Añadir mensaje de bienvenida
    _addWelcomeMessage();
    
    // Escuchar cambios en el idioma y actualizar el chat
    ever(_languageController.currentLanguage, (_) {
      clearChat();
    });
  }
  
  void _addWelcomeMessage() {
    String welcomeMessage = _languageController.currentLanguage.value == 'es'
        ? 'Hola, soy tu asistente virtual entomólogo. ¿En qué puedo ayudarte hoy? Puedes preguntarme sobre cualquier insecto o tema relacionado con la entomología.'
        : 'Hello, I am your virtual entomologist assistant. How can I help you today? You can ask me about any insect or topic related to entomology.';
    
    addMessage(
      ChatMessage(
        content: welcomeMessage,
        isUser: false,
      ),
    );
  }
  
  void addMessage(ChatMessage message) {
    messages.add(message);
  }
  
  Future<void> sendQuestion(String question, {int? insectId, String? insectName}) async {
    if (question.trim().isEmpty) return;
    
    // Añadir la pregunta del usuario a la lista de mensajes
    final userMessage = ChatMessage(
      content: question,
      isUser: true,
    );
    addMessage(userMessage);
    
    // Mostrar indicador de carga
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Enviar la pregunta al backend con el idioma actual de la aplicación
      final response = await _chatbotService.sendQuestion(
        question: question,
        insectId: insectId,
        insectName: insectName,
        language: _languageController.currentLanguage.value,
      );
      
      // Añadir la respuesta del asistente
      final botMessage = ChatMessage(
        content: response.answer,
        isUser: false,
      );
      addMessage(botMessage);
    } catch (e) {
      errorMessage.value = e.toString();
      // Añadir mensaje de error
      addMessage(ChatMessage(
        content: 'Lo siento, ha ocurrido un error. Por favor, inténtalo de nuevo más tarde.',
        isUser: false,
      ));
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearChat() {
    messages.clear();
    // Añadir mensaje de bienvenida nuevamente
    _addWelcomeMessage();
  }
  

}
