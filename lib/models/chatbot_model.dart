class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatbotResponse {
  final String answer;
  final Map<String, dynamic>? insectInfo;

  ChatbotResponse({
    required this.answer,
    this.insectInfo,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      answer: json['answer'],
      insectInfo: json['insect_info'],
    );
  }
}

enum ChatLanguage {
  spanish,
  english
}

extension ChatLanguageExtension on ChatLanguage {
  String get code {
    switch (this) {
      case ChatLanguage.spanish:
        return 'es';
      case ChatLanguage.english:
        return 'en';
    }
  }
  
  String get displayName {
    switch (this) {
      case ChatLanguage.spanish:
        return 'Español';
      case ChatLanguage.english:
        return 'English';
    }
  }
}
