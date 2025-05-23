// No se requieren importaciones adicionales

import 'package:insectos_app/config/api_config.dart';

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
      // IMPORTANTE: Usar directamente la URL correcta sin variables intermedias
      // Hardcodear la URL para evitar que Coolify la reemplace
      photoUrl =
          '${ApiConfig.baseUrl}/api/proxy/image?url=${Uri.encodeComponent(originalUrl)}';

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
