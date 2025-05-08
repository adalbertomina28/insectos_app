import 'dart:convert';

class IdentificationResult {
  final String status;
  final String? message;
  final List<IdentificationMatch> results;

  IdentificationResult({
    required this.status,
    this.message,
    required this.results,
  });

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>? ?? [];

    return IdentificationResult(
      status: json['status'] as String,
      message: json['message'] as String?,
      results: resultsList
          .map((result) =>
              IdentificationMatch.fromJson(result as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IdentificationMatch {
  final int taxonId;
  final String name;
  final String? preferredCommonName;
  final String? scientificName;
  final double score;
  final String? photoUrl;
  final String? rank;

  IdentificationMatch({
    required this.taxonId,
    required this.name,
    this.preferredCommonName,
    this.scientificName,
    required this.score,
    this.photoUrl,
    this.rank,
  });

  factory IdentificationMatch.fromJson(Map<String, dynamic> json) {
    // Extraer la URL de la foto si está disponible
    String? photoUrl;
    if (json['taxon'] != null &&
        json['taxon']['default_photo'] != null &&
        json['taxon']['default_photo']['medium_url'] != null) {
      final originalUrl =
          json['taxon']['default_photo']['medium_url'] as String;
      // Ofuscar la URL usando codificación Base64
      // URL codificada en Base64: 'https://api.insectlab.app'
      const encodedUrl = 'aHR0cHM6Ly9hcGkuaW5zZWN0bGFiLmFwcA==';
      String apiUrl;
      try {
        // Decodificar la URL desde Base64
        final bytes = base64.decode(encodedUrl);
        apiUrl = utf8.decode(bytes);
      } catch (e) {
        // Fallback en caso de error (usando valores ASCII)
        apiUrl = String.fromCharCodes([
          104, 116, 116, 112, 115, 58, 47, 47, 97, 112, 105, 46, 
          105, 110, 115, 101, 99, 116, 108, 97, 98, 46, 97, 112, 112
        ]);
      }
      photoUrl =
          '$apiUrl/api/proxy/image?url=${Uri.encodeComponent(originalUrl)}';
    }

    return IdentificationMatch(
      taxonId: json['taxon']?['id'] as int? ?? json['id'] as int? ?? 0,
      name: json['taxon']?['name'] as String? ??
          json['name'] as String? ??
          'Desconocido',
      preferredCommonName: json['taxon']?['preferred_common_name'] as String? ??
          json['preferred_common_name'] as String?,
      scientificName: json['taxon']?['scientific_name'] as String? ??
          json['scientific_name'] as String?,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      photoUrl: photoUrl,
      rank: json['taxon']?['rank'] as String? ?? json['rank'] as String?,
    );
  }

  // Obtener el porcentaje de confianza formateado
  String get confidencePercentage => '${(score * 100).toStringAsFixed(1)}%';
}
