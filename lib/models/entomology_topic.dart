class EntomologyTopic {
  final String title;
  final String description;
  final List<String> content;

  const EntomologyTopic({
    required this.title,
    required this.description,
    required this.content,
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
