class Insect {
  final String name;
  final String scientificName;
  final String description;
  final String imageUrl;
  final String emoji;
  final List<String> characteristics;
  final String impact;
  final List<String> categories; // Categorías principales (Benéficos, Plagas, Polinizadores)
  final List<String> habitat; // Tipos de hábitat (Terrestre, Acuático, Subterráneo)
  final String size; // Tamaño aproximado
  final List<String> diet; // Tipo de alimentación (Herbívoro, Carnívoro, Omnívoro)
  final List<String> activity; // Período de actividad (Diurno, Nocturno, Crepuscular)
  final List<String> distribution; // Distribución geográfica
  final List<String> lifecycle; // Etapas de vida (Huevo, Larva, Pupa, Adulto)
  final String behavior;
  final String ecologicalRole;
  final List<String> funFacts;
  final String conservationStatus;
  final RNAInfo? rnaInfo;
  final NanoTechInfo? nanoTechInfo;

  Insect({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.emoji,
    required this.characteristics,
    required this.impact,
    required this.categories,
    this.habitat = const [],
    required this.size,
    this.diet = const [],
    this.activity = const [],
    this.distribution = const [],
    this.lifecycle = const [],
    this.behavior = '',
    this.ecologicalRole = '',
    this.funFacts = const [],
    this.conservationStatus = '',
    this.rnaInfo,
    this.nanoTechInfo,
  });
}

class RNAInfo {
  final String description;
  final List<String> applications;
  final List<String> researchFindings;
  final String? videoUrl;

  RNAInfo({
    required this.description,
    required this.applications,
    required this.researchFindings,
    this.videoUrl,
  });
}

class NanoTechInfo {
  final String description;
  final List<String> applications;
  final List<String> innovations;
  final String? imageUrl;
  final List<String> futureProspects;

  NanoTechInfo({
    required this.description,
    required this.applications,
    required this.innovations,
    this.imageUrl,
    this.futureProspects = const [],
  });
}
