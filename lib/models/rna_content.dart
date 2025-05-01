import 'package:flutter/material.dart';

class RNAContent {
  final String title;
  final String description;
  final IconData iconData;
  final List<String> bulletPoints;

  RNAContent({
    required this.title,
    required this.description,
    required this.iconData,
    required this.bulletPoints,
  });
}

class RNACropExample {
  final String cropName;
  final String targetPest;
  final String description;
  final String effectiveness;
  final String implementationProcess;
  final String imageUrl;

  RNACropExample({
    required this.cropName,
    required this.targetPest,
    required this.description,
    required this.effectiveness,
    required this.implementationProcess,
    required this.imageUrl,
  });
}

final List<RNAContent> rnaBasics = [
  RNAContent(
    title: 'rna_what_is',
    description: 'rna_what_is_desc',
    iconData: Icons.biotech,
    bulletPoints: [
      'rna_bullet_essential',
      'rna_bullet_synthesis',
      'rna_bullet_control',
      'rna_bullet_tech',
    ],
  ),
  RNAContent(
    title: 'rna_mechanism',
    description: 'rna_mechanism_desc',
    iconData: Icons.schema,
    bulletPoints: [
      'rna_bullet_silencing',
      'rna_bullet_natural',
      'rna_bullet_effective',
      'rna_bullet_impact',
    ],
  ),
  RNAContent(
    title: 'rna_action',
    description: 'rna_action_desc',
    iconData: Icons.science,
    bulletPoints: [
      'rna_bullet_identification',
      'rna_bullet_design',
      'rna_bullet_formulation',
      'rna_bullet_application',
    ],
  ),
];

final List<RNACropExample> cropExamples = [
  RNACropExample(
    cropName: 'crop_rice',
    targetPest: 'pest_sogata',
    description: 'rice_desc',
    effectiveness: 'rice_effectiveness',
    implementationProcess: 'rice_process',
    imageUrl: 'assets/images/rna/arroz-panama.jpg',
  ),
  RNACropExample(
    cropName: 'crop_coffee',
    targetPest: 'pest_coffee_borer',
    description: 'coffee_desc',
    effectiveness: 'coffee_effectiveness',
    implementationProcess: 'coffee_process',
    imageUrl: 'assets/images/rna/cafe-panama.jpg',
  ),
  RNACropExample(
    cropName: 'crop_banana',
    targetPest: 'pest_black_weevil',
    description: 'banana_desc',
    effectiveness: 'banana_effectiveness',
    implementationProcess: 'banana_process',
    imageUrl: 'assets/images/rna/platano-panama.jpg',
  ),
  RNACropExample(
    cropName: 'crop_watermelon',
    targetPest: 'pest_whitefly',
    description: 'watermelon_desc',
    effectiveness: 'watermelon_effectiveness',
    implementationProcess: 'watermelon_process',
    imageUrl: 'assets/images/rna/sandia-panama.jpg',
  ),
];
