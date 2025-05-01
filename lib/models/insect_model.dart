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
  final String? wikipediaSummary;
  final Map<String, dynamic>? conservationStatus;
  final List<Map<String, dynamic>>? ancestors;

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
    this.wikipediaSummary,
    this.conservationStatus,
    this.ancestors,
  });

  factory Insect.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['default_photo']?['medium_url'] as String?;
    if (photoUrl != null) {
      // Convertir la URL de iNaturalist a nuestra URL proxy
      final Uri originalUri = Uri.parse(photoUrl);
      // Usar 10.0.2.2 para emulador Android en lugar de localhost
      photoUrl =
          'https://insectlab-backend-13e7bfe70f0a.herokuapp.com/api/proxy/image?url=${Uri.encodeComponent(photoUrl)}';
      // Para dispositivos físicos, usar la IP de la computadora en la red local
      // photoUrl = 'http://192.168.1.X:8000/api/proxy/image?url=${Uri.encodeComponent(photoUrl)}';
    }

    return Insect(
      id: json['id'] as int,
      name: json['name'] as String,
      scientificName: json['scientific_name'] as String?,
      preferredCommonName: json['preferred_common_name'] as String?,
      wikipediaUrl: json['wikipedia_url'] as String?,
      defaultPhoto: photoUrl,
      observationsCount: json['observations_count'] as int?,
      rank: json['rank'] as String?,
      ancestorTaxa:
          json['ancestors']?.map((t) => t['name'])?.join(' > ') as String?,
      wikipediaSummary: json['wikipedia_summary'] as String?,
      conservationStatus: json['conservation_status'] as Map<String, dynamic>?,
      ancestors:
          (json['ancestors'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'scientific_name': scientificName,
        'preferred_common_name': preferredCommonName,
        'wikipedia_url': wikipediaUrl,
        'default_photo':
            defaultPhoto != null ? {'medium_url': defaultPhoto} : null,
        'observations_count': observationsCount,
        'rank': rank,
        'ancestor_taxa': ancestorTaxa,
        'wikipedia_summary': wikipediaSummary,
        'conservation_status': conservationStatus,
        'ancestors': ancestors,
      };
}
