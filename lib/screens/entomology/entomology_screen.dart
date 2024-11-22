import 'package:flutter/material.dart';
import '../../models/entomology_topic.dart';
import '../../theme/app_theme.dart';

class EntomologyScreen extends StatelessWidget {
  EntomologyScreen({super.key});

  final List<EntomologyTopic> topics = [
    EntomologyTopic(
      title: '¿Qué es la Entomología?',
      description: 'La ciencia que estudia los insectos y su relación con el medio ambiente, los seres humanos y otros organismos.',
      content: [
        'La entomología es una rama de la zoología que se centra en el estudio científico de los insectos.',
        'Abarca diversos aspectos como la biología, ecología, morfología, fisiología, comportamiento y clasificación de los insectos.',
        'Es fundamental en la agricultura, medicina, conservación y otros campos científicos.',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Historia de la Entomología',
          content: [
            'Origen en la antigua civilización con observaciones de Aristóteles',
            'Desarrollo durante el Renacimiento con estudios sistemáticos',
            'Evolución moderna con técnicas moleculares y genéticas',
            'Contribuciones importantes en control de plagas y medicina',
          ],
        ),
      ],
    ),
    EntomologyTopic(
      title: 'Características de los Insectos',
      description: 'Rasgos distintivos que definen a los insectos como clase dentro del reino animal.',
      content: [
        'Cuerpo dividido en tres partes: cabeza, tórax y abdomen',
        'Tres pares de patas articuladas',
        'Un par de antenas',
        'Generalmente dos pares de alas (aunque algunos no tienen)',
        'Exoesqueleto de quitina',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Anatomía Externa',
          content: [
            'Cabeza: ojos compuestos, ocelos, antenas y aparato bucal',
            'Tórax: patas y alas, adaptadas para diferentes funciones',
            'Abdomen: órganos reproductores y respiratorios',
          ],
        ),
        EntomologySubtopic(
          title: 'Anatomía Interna',
          content: [
            'Sistema digestivo: adaptado a diferentes dietas',
            'Sistema circulatorio: abierto, con hemolinfa',
            'Sistema respiratorio: tráqueas y espiráculos',
            'Sistema nervioso: cerebro y cadena nerviosa ventral',
          ],
        ),
      ],
    ),
    EntomologyTopic(
      title: 'Clasificación de Insectos',
      description: 'Organización taxonómica de los insectos basada en sus características morfológicas y evolutivas.',
      content: [
        'Los insectos pertenecen al Filo Arthropoda',
        'Clase Insecta: la más diversa del reino animal',
        'Más de un millón de especies descritas',
        'Se estiman entre 5-30 millones de especies totales',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Órdenes Principales',
          content: [
            'Coleoptera (escarabajos): el orden más numeroso',
            'Lepidoptera (mariposas y polillas)',
            'Hymenoptera (abejas, avispas y hormigas)',
            'Diptera (moscas y mosquitos)',
            'Hemiptera (chinches y cigarras)',
            'Orthoptera (saltamontes y grillos)',
          ],
        ),
      ],
    ),
    EntomologyTopic(
      title: 'Ciclos de Vida',
      description: 'Diferentes tipos de metamorfosis y etapas de desarrollo en los insectos.',
      content: [
        'Metamorfosis completa (holometábola)',
        'Metamorfosis incompleta (hemimetábola)',
        'Desarrollo directo (ametábola)',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Metamorfosis Completa',
          content: [
            'Huevo',
            'Larva (oruga, gusano, etc.)',
            'Pupa (crisálida)',
            'Adulto (imago)',
          ],
        ),
        EntomologySubtopic(
          title: 'Metamorfosis Incompleta',
          content: [
            'Huevo',
            'Ninfa (similar al adulto)',
            'Adulto',
          ],
        ),
      ],
    ),
    EntomologyTopic(
      title: 'Importancia Económica',
      description: 'El impacto de los insectos en la economía y la sociedad humana.',
      content: [
        'Polinización de cultivos',
        'Control biológico de plagas',
        'Producción de miel, seda y otros productos',
        'Daños a cultivos y productos almacenados',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Insectos Benéficos',
          content: [
            'Polinizadores: abejas, mariposas, polillas',
            'Controladores biológicos: mariquitas, avispas parasitoides',
            'Productores: abejas melíferas, gusanos de seda',
            'Descomponedores: escarabajos, moscas',
          ],
        ),
        EntomologySubtopic(
          title: 'Insectos Plaga',
          content: [
            'Plagas agrícolas',
            'Plagas forestales',
            'Plagas urbanas',
            'Vectores de enfermedades',
          ],
        ),
      ],
    ),
    EntomologyTopic(
      title: 'Métodos de Estudio',
      description: 'Técnicas y herramientas utilizadas en la investigación entomológica.',
      content: [
        'Colecta y preservación de especímenes',
        'Identificación taxonómica',
        'Estudios de comportamiento',
        'Análisis moleculares',
      ],
      subtopics: [
        EntomologySubtopic(
          title: 'Técnicas de Campo',
          content: [
            'Trampas de luz',
            'Redes entomológicas',
            'Trampas de caída',
            'Muestreo por golpeo',
          ],
        ),
        EntomologySubtopic(
          title: 'Técnicas de Laboratorio',
          content: [
            'Microscopía',
            'Disección',
            'Análisis de ADN',
            'Cría de insectos',
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Entomología',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showTopicDetails(context, topic),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTopicDetails(BuildContext context, EntomologyTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            topic.description,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...topic.content.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          )),
                          if (topic.subtopics.isNotEmpty) ...[
                            const SizedBox(height: 32),
                            ...topic.subtopics.map((subtopic) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subtopic.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...subtopic.content.map((item) => Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.primaryGradient,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 24),
                              ],
                            )),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
