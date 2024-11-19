import 'package:flutter/foundation.dart';

@immutable
class TechResearchInfo {
  final String title;
  final String description;
  final Map<String, List<String>> processDiagram;
  final List<ResearchAdvance> advances;
  final List<TechnologyBenefit> benefits;
  final List<String> futureProspects;
  final String? mainResourceUrl;
  final String? mainVideoUrl;

  const TechResearchInfo({
    required this.title,
    required this.description,
    required this.processDiagram,
    required this.advances,
    required this.benefits,
    required this.futureProspects,
    this.mainResourceUrl,
    this.mainVideoUrl,
  });
}

@immutable
class ResearchAdvance {
  final String title;
  final String description;
  final String date;
  final String? resourceUrl;
  final String? videoUrl;

  const ResearchAdvance({
    required this.title,
    required this.description,
    required this.date,
    this.resourceUrl,
    this.videoUrl,
  });

  factory ResearchAdvance.fromJson(Map<String, dynamic> json) {
    return ResearchAdvance(
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      resourceUrl: json['resourceUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'resourceUrl': resourceUrl,
      'videoUrl': videoUrl,
    };
  }
}

@immutable
class TechnologyBenefit {
  final String title;
  final String description;
  final String icon;
  final String? learnMoreUrl;

  const TechnologyBenefit({
    required this.title,
    required this.description,
    required this.icon,
    this.learnMoreUrl,
  });

  factory TechnologyBenefit.fromJson(Map<String, dynamic> json) {
    return TechnologyBenefit(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      learnMoreUrl: json['learnMoreUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'learnMoreUrl': learnMoreUrl,
    };
  }
}
