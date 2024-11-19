import 'package:get/get.dart';
import '../models/tech_research_info.dart';

class TechResearchController extends GetxController {
  final Rx<TechResearchInfo?> researchInfo = Rx<TechResearchInfo?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadResearchInfo();
  }

  Future<void> loadResearchInfo() async {
    isLoading.value = true;
    try {
      // Simular carga de datos
      await Future.delayed(const Duration(seconds: 1));
      
      researchInfo.value = TechResearchInfo(
        title: 'RNA y Nanotecnología en Entomología',
        description: 'Descubre cómo la investigación moderna está revolucionando nuestro entendimiento de los insectos y su impacto en la agricultura.',
        mainResourceUrl: 'https://www.nature.com/subjects/entomology',
        mainVideoUrl: 'https://www.youtube.com/watch?v=example',
        processDiagram: {
          'Fase 1: Recolección': [
            'Muestreo en campo',
            'Preservación de especímenes',
            'Documentación inicial',
          ],
          'Fase 2: Análisis': [
            'Secuenciación de RNA',
            'Análisis microscópico',
            'Estudios comportamentales',
          ],
          'Fase 3: Aplicación': [
            'Desarrollo de protocolos',
            'Validación de resultados',
            'Implementación práctica',
          ],
        },
        advances: [
          ResearchAdvance(
            title: 'Descubrimiento de Nuevos Mecanismos de Resistencia',
            description: 'Investigadores identificaron patrones de expresión génica relacionados con la resistencia a pesticidas.',
            date: 'Marzo 2024',
            resourceUrl: 'https://www.sciencedirect.com/science/article/example1',
            videoUrl: 'https://www.youtube.com/watch?v=example1',
          ),
          ResearchAdvance(
            title: 'Innovación en Control Biológico',
            description: 'Desarrollo de nuevas técnicas de control utilizando RNA de interferencia.',
            date: 'Febrero 2024',
            resourceUrl: 'https://www.sciencedirect.com/science/article/example2',
          ),
          ResearchAdvance(
            title: 'Avances en Monitoreo de Plagas',
            description: 'Implementación de sistemas automatizados basados en IA para la detección temprana.',
            date: 'Enero 2024',
            videoUrl: 'https://www.youtube.com/watch?v=example3',
          ),
        ],
        benefits: [
          TechnologyBenefit(
            title: 'Agricultura Sostenible',
            description: 'Reducción significativa en el uso de pesticidas químicos mediante técnicas moleculares específicas.',
            icon: 'eco',
            learnMoreUrl: 'https://www.fao.org/sustainable-agriculture',
          ),
          TechnologyBenefit(
            title: 'Conservación de Especies',
            description: 'Mejor comprensión de las poblaciones de insectos beneficiosos y su preservación.',
            icon: 'nature',
            learnMoreUrl: 'https://www.iucn.org/resources/conservation-tool/red-list-ecosystem',
          ),
          TechnologyBenefit(
            title: 'Seguridad Alimentaria',
            description: 'Mayor protección de cultivos contra plagas mediante métodos avanzados de control.',
            icon: 'security',
            learnMoreUrl: 'https://www.who.int/news-room/fact-sheets/food-security',
          ),
        ],
        futureProspects: [
          'Desarrollo de nuevas técnicas de edición genética para control de plagas',
          'Implementación de sistemas de monitoreo en tiempo real',
          'Creación de bases de datos genómicas completas',
          'Desarrollo de métodos de control más específicos y sostenibles',
        ],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos de investigación',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
