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
    title: '¿Qué es el ARN?',
    description:
        'El ARN (Ácido Ribonucleico) es una molécula fundamental en el control biológico de insectos plaga.',
    iconData: Icons.biotech,
    bulletPoints: [
      'Molécula esencial para la vida',
      'Participa en la síntesis de proteínas',
      'Puede ser utilizado para control específico de plagas',
      'Tecnología de vanguardia en agricultura sostenible',
    ],
  ),
  RNAContent(
    title: 'Mecanismo de RNAi',
    description:
        'El ARN de interferencia (RNAi) es un mecanismo natural que puede ser utilizado para silenciar genes específicos en insectos plaga.',
    iconData: Icons.schema,
    bulletPoints: [
      'Silenciamiento génico específico',
      'Proceso natural y seguro',
      'Alta efectividad',
      'Mínimo impacto ambiental',
    ],
  ),
  RNAContent(
    title: 'Proceso de Acción',
    description:
        'El proceso de control mediante ARN implica varios pasos desde su diseño hasta su aplicación en campo.',
    iconData: Icons.science,
    bulletPoints: [
      'Identificación del gen objetivo',
      'Diseño de la secuencia de ARN',
      'Formulación del producto',
      'Aplicación en campo',
    ],
  ),
];

final List<RNACropExample> cropExamples = [
  RNACropExample(
    cropName: 'Arroz',
    targetPest: 'Sogata (Tagosodes orizicolus)',
    description:
        'Control de la sogata, vector del virus de la hoja blanca, mediante ARN específico que interrumpe genes esenciales para su desarrollo. Cultivo de gran importancia en las provincias de Chiriquí y Coclé.',
    effectiveness:
        '82% de reducción en la transmisión del virus de la hoja blanca',
    implementationProcess:
        'Aplicación foliar cada 10-14 días durante la etapa de crecimiento vegetativo',
    imageUrl: 'assets/images/rna/arroz-panama.jpg',
  ),
  RNACropExample(
    cropName: 'Café',
    targetPest: 'Broca del café (Hypothenemus hampei)',
    description:
        'Protección del cultivo de café contra la broca mediante tecnología de ARN. Especialmente relevante para las plantaciones de altura en Boquete y Volcán.',
    effectiveness: '88% de reducción en la infestación de granos',
    implementationProcess:
        'Tratamiento preventivo al inicio de la temporada y aplicaciones dirigidas durante la fructificación',
    imageUrl: 'assets/images/rna/cafe-panama.jpg',
  ),
  RNACropExample(
    cropName: 'Plátano',
    targetPest: 'Picudo negro (Cosmopolites sordidus)',
    description:
        'Control específico del picudo negro del plátano sin afectar a insectos benéficos. Cultivo fundamental en la economía de Barú y otras regiones del país.',
    effectiveness: '75% de reducción en daños al cormo y pseudotallo',
    implementationProcess:
        'Aplicación en trampas y tratamiento directo a la base de las plantas cada 30 días',
    imageUrl: 'assets/images/rna/platano-panama.jpg',
  ),
  RNACropExample(
    cropName: 'Sandía',
    targetPest: 'Mosca blanca (Bemisia tabaci)',
    description:
        'Manejo integrado de la mosca blanca en cultivos de sandía de la península de Azuero, principal zona productora de esta fruta en Panamá.',
    effectiveness: '80% de control de poblaciones en campo abierto',
    implementationProcess:
        'Aplicación semanal durante las primeras etapas del cultivo, combinado con otras estrategias de manejo integrado',
    imageUrl: 'assets/images/rna/sandia-panama.jpg',
  ),
];
