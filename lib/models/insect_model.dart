class Insect {
  final int id;
  final String name;
  final String? scientificName;
  final String? preferredCommonName;
  final String? wikipediaUrl;
  final String? defaultPhoto;
  final int? observationsCount;
  final String? rank;
  final String? ancestorTaxa;

  Insect({
    required this.id,
    required this.name,
    this.scientificName,
    this.preferredCommonName,
    this.wikipediaUrl,
    this.defaultPhoto,
    this.observationsCount,
    this.rank,
    this.ancestorTaxa,
  });

  factory Insect.fromJson(Map<String, dynamic> json) {
    return Insect(
      id: json['id'] as int,
      name: json['name'] as String,
      scientificName: json['scientific_name'] as String?,
      preferredCommonName: json['preferred_common_name'] as String?,
      wikipediaUrl: json['wikipedia_url'] as String?,
      defaultPhoto: json['default_photo']?['medium_url'] as String?,
      observationsCount: json['observations_count'] as int?,
      rank: json['rank'] as String?,
      ancestorTaxa: json['ancestor_taxa']?.map((t) => t['name'])?.join(' > ') as String?,
    );
  }
}
