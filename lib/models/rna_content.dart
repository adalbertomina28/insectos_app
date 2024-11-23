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
    description: 'El ARN (Ácido Ribonucleico) es una molécula fundamental en el control biológico de insectos plaga.',
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
    description: 'El ARN de interferencia (RNAi) es un mecanismo natural que puede ser utilizado para silenciar genes específicos en insectos plaga.',
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
    description: 'El proceso de control mediante ARN implica varios pasos desde su diseño hasta su aplicación en campo.',
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
    cropName: 'Maíz',
    targetPest: 'Gusano cogollero (Spodoptera frugiperda)',
    description: 'Control del gusano cogollero mediante ARN específico que interrumpe genes esenciales para su desarrollo.',
    effectiveness: '85% de reducción en daño al cultivo',
    implementationProcess: 'Aplicación foliar cada 14 días durante el período crítico',
    imageUrl: 'assets/images/placeholder.png',
  ),
  RNACropExample(
    cropName: 'Algodón',
    targetPest: 'Gusano rosado (Pectinophora gossypiella)',
    description: 'Protección del cultivo de algodón contra el gusano rosado mediante tecnología de ARN.',
    effectiveness: '90% de control en condiciones óptimas',
    implementationProcess: 'Tratamiento de semillas y aplicación foliar',
    imageUrl: 'assets/images/placeholder.png',
  ),
  RNACropExample(
    cropName: 'Papa',
    targetPest: 'Escarabajo de la papa (Leptinotarsa decemlineata)',
    description: 'Control específico del escarabajo de la papa sin afectar a insectos benéficos.',
    effectiveness: '80% de reducción en población de la plaga',
    implementationProcess: 'Aplicación cada 10 días durante la temporada de crecimiento',
    imageUrl: 'assets/images/placeholder.png',
  ),
];
