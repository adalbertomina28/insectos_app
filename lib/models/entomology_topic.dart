class EntomologyTopic {
  final String title;
  final String description;
  final List<String> content;
  final String? imageUrl;
  final List<EntomologySubtopic>? subtopics;

  EntomologyTopic({
    required this.title,
    required this.description,
    required this.content,
    this.imageUrl,
    this.subtopics,
  });
}

class EntomologySubtopic {
  final String title;
  final List<String> content;
  final String? imageUrl;

  EntomologySubtopic({
    required this.title,
    required this.content,
    this.imageUrl,
  });
}
