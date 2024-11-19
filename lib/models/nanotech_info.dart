import 'package:flutter/foundation.dart';

@immutable
class NanoTechInfo {
  final String title;
  final String description;
  final List<String> applications;
  final List<String> researchFindings;
  final List<String> imageUrls;
  final String? videoUrl;
  final Map<String, String>? additionalInfo;

  const NanoTechInfo({
    required this.title,
    required this.description,
    required this.applications,
    required this.researchFindings,
    required this.imageUrls,
    this.videoUrl,
    this.additionalInfo,
  });

  factory NanoTechInfo.fromJson(Map<String, dynamic> json) {
    return NanoTechInfo(
      title: json['title'] as String,
      description: json['description'] as String,
      applications: List<String>.from(json['applications'] as List),
      researchFindings: List<String>.from(json['researchFindings'] as List),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      videoUrl: json['videoUrl'] as String?,
      additionalInfo: json['additionalInfo'] != null
          ? Map<String, String>.from(json['additionalInfo'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'applications': applications,
      'researchFindings': researchFindings,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'additionalInfo': additionalInfo,
    };
  }

  NanoTechInfo copyWith({
    String? title,
    String? description,
    List<String>? applications,
    List<String>? researchFindings,
    List<String>? imageUrls,
    String? videoUrl,
    Map<String, String>? additionalInfo,
  }) {
    return NanoTechInfo(
      title: title ?? this.title,
      description: description ?? this.description,
      applications: applications ?? this.applications,
      researchFindings: researchFindings ?? this.researchFindings,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NanoTechInfo &&
        other.title == title &&
        other.description == description &&
        listEquals(other.applications, applications) &&
        listEquals(other.researchFindings, researchFindings) &&
        listEquals(other.imageUrls, imageUrls) &&
        other.videoUrl == videoUrl &&
        mapEquals(other.additionalInfo, additionalInfo);
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      description,
      Object.hashAll(applications),
      Object.hashAll(researchFindings),
      Object.hashAll(imageUrls),
      videoUrl,
      additionalInfo != null ? Object.hashAll(additionalInfo!.entries) : null,
    );
  }
}
