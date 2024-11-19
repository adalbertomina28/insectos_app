class Insect {
  final String name;
  final String scientificName;
  final String description;
  final String imageUrl;
  final List<String> characteristics;
  final String impact;
  final RNAInfo? rnaInfo;
  final NanoTechInfo? nanoTechInfo;

  Insect({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.characteristics,
    required this.impact,
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
  final List<String> futureProspects;
  final String? imageUrl;

  NanoTechInfo({
    required this.description,
    required this.applications,
    required this.innovations,
    required this.futureProspects,
    this.imageUrl,
  });
}
