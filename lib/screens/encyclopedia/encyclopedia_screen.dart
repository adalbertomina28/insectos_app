import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import '../../models/insect.dart';
import '../../theme/app_theme.dart';

class EncyclopediaController extends GetxController {
  final RxList<Insect> filteredInsects = <Insect>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Todos'.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = ['Todos', 'Benéficos', 'Plagas', 'Polinizadores'];
  
  final List<Insect> allInsects = [
    Insect(
      name: 'Mariposa Monarca',
      scientificName: 'Danaus plexippus',
      description: 'La mariposa monarca es conocida por su impresionante migración y su importancia en la polinización.',
      imageUrl: 'assets/images/insects/monarch_butterfly.jpg',
      characteristics: [
        'Alas de color naranja con venas negras',
        'Envergadura de 8.9-10.2 cm',
        'Migra largas distancias',
      ],
      impact: 'Polinizador importante para muchas plantas y cultivos.',
      rnaInfo: RNAInfo(
        description: 'Las investigaciones sobre el ARN en mariposas monarca han revelado mecanismos moleculares fascinantes que controlan su migración y metamorfosis.',
        applications: [
          'Estudio de genes involucrados en la navegación',
          'Comprensión de los ciclos circadianos',
          'Desarrollo de técnicas de conservación basadas en ARN',
        ],
        researchFindings: [
          'Identificación de genes específicos que controlan la orientación magnética',
          'Descubrimiento de ARN no codificante en la regulación del desarrollo de las alas',
          'Papel del ARN en la resistencia a toxinas de plantas',
        ],
        videoUrl: 'https://example.com/monarch_rna_research.mp4',
      ),
      nanoTechInfo: NanoTechInfo(
        description: 'La estructura de las alas de la mariposa monarca ha inspirado desarrollos en nanotecnología para crear superficies autolimpiantes y fotónicas.',
        applications: [
          'Desarrollo de paneles solares más eficientes',
          'Creación de superficies hidrofóbicas',
          'Diseño de sensores ambientales',
        ],
        innovations: [
          'Nanopartículas inspiradas en las escamas de las alas',
          'Materiales fotónicos bioinspirados',
          'Sistemas de navegación basados en sensores magnéticos naturales',
        ],
        futureProspects: [
          'Desarrollo de tejidos inteligentes autolimpiantes',
          'Mejora en la eficiencia de células solares',
          'Nuevos sistemas de navegación biomédicos',
        ],
        imageUrl: 'assets/images/nanotech/monarch_wing_structure.jpg',
      ),
    ),
    Insect(
      name: 'Abeja de la Miel',
      scientificName: 'Apis mellifera',
      description: 'Las abejas son polinizadores cruciales para la agricultura y producen miel.',
      imageUrl: 'assets/images/insects/honey_bee.jpg',
      characteristics: [
        'Cuerpo rayado negro y amarillo',
        'Tamaño de 12-15 mm',
        'Vive en colonias organizadas',
      ],
      impact: 'Vital para la polinización de cultivos y la producción de miel.',
      rnaInfo: RNAInfo(
        description: 'El estudio del ARN en abejas ha revolucionado nuestra comprensión de la inmunidad social y el comportamiento colectivo.',
        applications: [
          'Desarrollo de tratamientos contra patógenos',
          'Mejora de la resistencia a pesticidas',
          'Estudio de la memoria y aprendizaje social',
        ],
        researchFindings: [
          'Descubrimiento de ARN interferente en la inmunidad social',
          'Identificación de marcadores genéticos para la resistencia a enfermedades',
          'Papel del ARN en la diferenciación de castas',
        ],
        videoUrl: 'https://example.com/bee_rna_research.mp4',
      ),
      nanoTechInfo: NanoTechInfo(
        description: 'La estructura del ojo compuesto y las propiedades de los pelos de las abejas han inspirado innovaciones en nanosensores y materiales.',
        applications: [
          'Desarrollo de sensores de luz ultravioleta',
          'Creación de superficies adhesivas reversibles',
          'Diseño de sistemas de visión artificial',
        ],
        innovations: [
          'Nanoestructuras inspiradas en ojos compuestos',
          'Materiales adhesivos biomédicos',
          'Sensores de polen nanoestructurados',
        ],
        futureProspects: [
          'Sistemas de visión artificial mejorados',
          'Nuevos materiales para robots polinizadores',
          'Sensores ambientales más precisos',
        ],
        imageUrl: 'assets/images/nanotech/bee_eye_structure.jpg',
      ),
    ),
    Insect(
      name: 'Gorgojo del Maíz',
      scientificName: 'Sitophilus zeamais',
      description: 'Pequeño escarabajo que afecta principalmente al maíz almacenado. Es una de las plagas más destructivas en granos almacenados en regiones tropicales y subtropicales.',
      imageUrl: 'assets/images/insects/maize_weevil.jpg',
      characteristics: [
        'Longitud: 2.5-4mm',
        'Color marrón oscuro a negro',
        'Rostro alargado característico',
        'Élitros con puntuaciones alineadas'
      ],
      impact: 'Puede causar pérdidas de hasta el 40% en granos almacenados. Afecta la calidad y el valor comercial del maíz.',
    ),
    Insect(
      name: 'Mosca Blanca',
      scientificName: 'Bemisia tabaci',
      description: 'Insecto pequeño que afecta a diversos cultivos hortícolas. Vector importante de enfermedades virales en plantas.',
      imageUrl: 'assets/images/insects/whitefly.jpg',
      characteristics: [
        'Longitud: 1-2mm',
        'Color blanco',
        'Alas transparentes cubiertas de cera',
        'Ninfas translúcidas'
      ],
      impact: 'Vector de más de 100 virus de plantas. Reduce significativamente el rendimiento de cultivos como tomate, chile y algodón.',
    ),
    Insect(
      name: 'Gusano Cogollero',
      scientificName: 'Spodoptera frugiperda',
      description: 'Lepidóptero que ataca principalmente al maíz y otros cultivos de gramíneas. Larva muy voraz que puede destruir cultivos enteros.',
      imageUrl: 'assets/images/insects/fall_armyworm.jpg',
      characteristics: [
        'Larva: 35-40mm',
        'Color variable, desde verde hasta café oscuro',
        'Marca en Y invertida en la cabeza',
        'Adulto: polilla de color gris-café'
      ],
      impact: 'Puede causar pérdidas totales en cultivos de maíz. Afecta también a sorgo, arroz y otros cereales.',
    ),
    Insect(
      name: 'Trips de las Flores',
      scientificName: 'Frankliniella occidentalis',
      description: 'Pequeño insecto que afecta principalmente a flores y frutos. Causa daños directos por alimentación e indirectos como vector de virus.',
      imageUrl: 'assets/images/insects/western_flower_thrips.jpg',
      characteristics: [
        'Longitud: 1-1.5mm',
        'Color amarillento a marrón',
        'Alas con flecos característicos',
        'Aparato bucal raspador-chupador'
      ],
      impact: 'Transmite virus como el TSWV. Afecta la calidad estética de flores y frutos.',
    ),
    Insect(
      name: 'Pulgón Verde',
      scientificName: 'Myzus persicae',
      description: 'Áfido polífago que afecta a numerosos cultivos. Importante vector de virus en plantas hortícolas.',
      imageUrl: 'assets/images/insects/green_peach_aphid.jpg',
      characteristics: [
        'Longitud: 1.2-2.1mm',
        'Color verde claro a rosado',
        'Sifones largos y oscuros',
        'Formas aladas y ápteras'
      ],
      impact: 'Vector de más de 100 virus diferentes. Causa daños por succión de savia y producción de melaza.',
    ),
    Insect(
      name: 'Gallina Ciega',
      scientificName: 'Phyllophaga spp.',
      description: 'Larva de escarabajo que ataca raíces de diversos cultivos. Común en cultivos de temporal.',
      imageUrl: 'assets/images/insects/white_grub.jpg',
      characteristics: [
        'Larva: 20-30mm',
        'Color blanco cremoso',
        'Cabeza café rojiza',
        'Cuerpo en forma de "C"'
      ],
      impact: 'Daña severamente sistemas radiculares. Puede causar pérdidas totales en cultivos como maíz y frijol.',
    ),
    Insect(
      name: 'Picudo del Chile',
      scientificName: 'Anthonomus eugenii',
      description: 'Pequeño curculiónido específico del chile. Las larvas se desarrollan dentro de los frutos.',
      imageUrl: 'assets/images/insects/pepper_weevil.jpg',
      characteristics: [
        'Adulto: 2-3.5mm',
        'Color negro a gris oscuro',
        'Rostro largo y curvo',
        'Élitros con pubescencia'
      ],
      impact: 'Puede causar pérdidas de hasta 80% en cultivos de chile. Afecta directamente la producción de frutos.',
    ),
    Insect(
      name: 'Gusano del Cuerno',
      scientificName: 'Manduca sexta',
      description: 'Gran lepidóptero que afecta a plantas solanáceas. Larva voraz que consume gran cantidad de follaje.',
      imageUrl: 'assets/images/insects/tobacco_hornworm.jpg',
      characteristics: [
        'Larva: hasta 100mm',
        'Color verde brillante',
        'Cuerno posterior característico',
        'Franjas laterales blancas y negras'
      ],
      impact: 'Defoliador importante en cultivos de tomate y tabaco. Puede causar pérdidas significativas si no se controla.',
    ),
    Insect(
      name: 'Araña Roja',
      scientificName: 'Tetranychus urticae',
      description: 'Ácaro fitófago que afecta a numerosos cultivos. Forma colonias en el envés de las hojas.',
      imageUrl: 'assets/images/insects/red_spider_mite.jpg',
      characteristics: [
        'Longitud: 0.4-0.5mm',
        'Color variable, rojizo a verdoso',
        'Manchas oscuras dorsales',
        'Produce telarañas características'
      ],
      impact: 'Reduce la capacidad fotosintética. Puede causar defoliación en infestaciones severas.',
    ),
    Insect(
      name: 'Barrenador del Tallo',
      scientificName: 'Diatraea saccharalis',
      description: 'Lepidóptero que barrena tallos de gramíneas. Importante plaga en caña de azúcar.',
      imageUrl: 'assets/images/insects/sugarcane_borer.jpg',
      characteristics: [
        'Larva: 25-30mm',
        'Color crema con puntos oscuros',
        'Cabeza marrón',
        'Adulto: polilla color paja'
      ],
      impact: 'Reduce el rendimiento y calidad de la caña. Facilita la entrada de patógenos.',
    ),
    Insect(
      name: 'Chinche Verde',
      scientificName: 'Nezara viridula',
      description: 'Hemíptero que afecta a leguminosas y otros cultivos. Se alimenta de frutos y semillas.',
      imageUrl: 'assets/images/insects/green_stink_bug.jpg',
      characteristics: [
        'Longitud: 14-16mm',
        'Color verde brillante',
        'Forma de escudo',
        'Antenas segmentadas'
      ],
      impact: 'Daña directamente frutos y semillas. Reduce la calidad y rendimiento de cultivos como soya y frijol.',
    ),
    Insect(
      name: 'Minador de la Hoja',
      scientificName: 'Liriomyza spp.',
      description: 'Pequeña mosca cuyas larvas crean galerías en las hojas. Afecta principalmente a hortalizas.',
      imageUrl: 'assets/images/insects/leafminer.jpg',
      characteristics: [
        'Adulto: 2-3mm',
        'Color negro con amarillo',
        'Larvas: ápodas y amarillentas',
        'Minas serpenteantes características'
      ],
      impact: 'Reduce la capacidad fotosintética. Puede causar defoliación en ataques severos.',
    ),
    Insect(
      name: 'Palomilla Dorso de Diamante',
      scientificName: 'Plutella xylostella',
      description: 'Microlepidóptero específico de crucíferas. Principal plaga en cultivos de col y brócoli.',
      imageUrl: 'assets/images/insects/diamondback_moth.jpg',
      characteristics: [
        'Adulto: 8-10mm',
        'Patrón dorsal en forma de diamantes',
        'Larvas verde claro',
        'Alta resistencia a insecticidas'
      ],
      impact: 'Puede causar pérdidas totales en crucíferas. Difícil de controlar por su resistencia a insecticidas.',
    ),
    Insect(
      name: 'Gusano Soldado',
      scientificName: 'Spodoptera exigua',
      description: 'Lepidóptero polífago que afecta a diversos cultivos. Las larvas son activas principalmente de noche.',
      imageUrl: 'assets/images/insects/beet_armyworm.jpg',
      characteristics: [
        'Larva: 25-35mm',
        'Color variable, verde a marrón',
        'Líneas laterales claras',
        'Comportamiento gregario inicial'
      ],
      impact: 'Causa defoliación severa. Afecta especialmente a cultivos de hortalizas y algodón.',
    ),
    Insect(
      name: 'Picudo del Algodón',
      scientificName: 'Anthonomus grandis',
      description: 'Curculiónido específico del algodón. Considerado una de las plagas más destructivas de este cultivo.',
      imageUrl: 'assets/images/insects/cotton_boll_weevil.jpg',
      characteristics: [
        'Adulto: 4-8mm',
        'Color café rojizo',
        'Rostro largo y delgado',
        'Larvas curvas y blanquecinas'
      ],
      impact: 'Puede destruir hasta el 90% de las bellotas de algodón. Históricamente ha causado grandes pérdidas económicas.',
    ),
    Insect(
      name: 'Mosquita Blanca de los Invernaderos',
      scientificName: 'Trialeurodes vaporariorum',
      description: 'Plaga importante en cultivos protegidos. Similar a Bemisia tabaci pero con diferencias morfológicas y de comportamiento.',
      imageUrl: 'assets/images/insects/greenhouse_whitefly.jpg',
      characteristics: [
        'Adulto: 1.5mm',
        'Alas blancas paralelas al cuerpo',
        'Ninfas con filamentos cerosos',
        'Prefiere climas templados'
      ],
      impact: 'Causa daños directos por succión de savia y daños indirectos como vector de virus.',
    ),
    Insect(
      name: 'Gusano Elotero',
      scientificName: 'Helicoverpa zea',
      description: 'Lepidóptero que ataca principalmente los elotes del maíz. También afecta a tomate y algodón.',
      imageUrl: 'assets/images/insects/corn_earworm.jpg',
      characteristics: [
        'Larva: hasta 40mm',
        'Color variable según alimentación',
        'Microespinas en la cutícula',
        'Comportamiento caníbal'
      ],
      impact: 'Daña directamente los granos en formación. Reduce la calidad comercial del maíz.',
    ),
    Insect(
      name: 'Trips del Aguacate',
      scientificName: 'Scirtothrips perseae',
      description: 'Pequeño insecto específico del aguacate. Causa daños en frutos y follaje joven.',
      imageUrl: 'assets/images/insects/avocado_thrips.jpg',
      characteristics: [
        'Adulto: 1mm',
        'Color amarillo pálido',
        'Alas con flecos',
        'Alta movilidad'
      ],
      impact: 'Causa deformaciones en frutos jóvenes. Afecta la calidad comercial del aguacate.',
    ),
    Insect(
      name: 'Barrenador del Aguacate',
      scientificName: 'Copturus aguacatae',
      description: 'Curculiónido específico del aguacate. Las larvas barrenan ramas y frutos.',
      imageUrl: 'assets/images/insects/avocado_borer.jpg',
      characteristics: [
        'Adulto: 4-5mm',
        'Color negro con escamas',
        'Rostro curvo',
        'Larvas blanquecinas'
      ],
      impact: 'Causa la muerte de ramas. Puede afectar severamente la producción de frutos.',
    ),
    Insect(
      name: 'Escama Armada',
      scientificName: 'Quadraspidiotus perniciosus',
      description: 'Insecto escama que afecta principalmente a frutales. Se fija y alimenta de la corteza.',
      imageUrl: 'assets/images/insects/san_jose_scale.jpg',
      characteristics: [
        'Hembra: 2mm diámetro',
        'Escama circular gris',
        'Macho alado diminuto',
        'Ninfas móviles inicialmente'
      ],
      impact: 'Debilita árboles frutales. Puede causar la muerte de ramas y reducir la producción.',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    filteredInsects.value = allInsects;
  }

  void filterInsects() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      filteredInsects.value = allInsects.where((insect) {
        final matchesSearch = insect.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            insect.scientificName.toLowerCase().contains(searchQuery.value.toLowerCase());
        
        final matchesCategory = selectedCategory.value == 'Todos' ||
            (selectedCategory.value == 'Benéficos' && insect.impact.contains('benéfico')) ||
            (selectedCategory.value == 'Plagas' && insect.impact.contains('plaga')) ||
            (selectedCategory.value == 'Polinizadores' && insect.impact.contains('polinizador'));
        
        return matchesSearch && matchesCategory;
      }).toList();
      isLoading.value = false;
    });
  }
}

class EncyclopediaScreen extends GetView<EncyclopediaController> {
  EncyclopediaScreen({Key? key}) : super(key: key) {
    Get.put(EncyclopediaController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Enciclopedia de Insectos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withGreen(150),
                      AppTheme.primaryColor.withBlue(150),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -10,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(
                            Icons.bug_report,
                            size: 180,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: 30,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Opacity(
                          opacity: 0.1,
                          child: Icon(
                            Icons.flutter_dash,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            controller.searchQuery.value = value;
                            controller.filterInsects();
                          },
                          decoration: InputDecoration(
                            hintText: 'Buscar insectos...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: controller.categories.map((category) {
                          return Obx(() {
                            final isSelected = controller.selectedCategory.value == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(category),
                                  onSelected: (selected) {
                                    controller.selectedCategory.value = category;
                                    controller.filterInsects();
                                  },
                                  backgroundColor: Colors.grey[50],
                                  selectedColor: AppTheme.primaryColor.withOpacity(0.15),
                                  checkmarkColor: AppTheme.primaryColor,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : Colors.grey[600],
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: isSelected
                                          ? AppTheme.primaryColor
                                          : Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (controller.filteredInsects.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/empty_search.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No se encontraron insectos en esta categoría',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prueba seleccionando otra categoría',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.all(AppTheme.spacing),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppTheme.spacing,
                crossAxisSpacing: AppTheme.spacing,
                itemBuilder: (context, index) {
                  final insect = controller.filteredInsects[index];
                  return InsectCard(insect: insect);
                },
                childCount: controller.filteredInsects.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class InsectCard extends StatelessWidget {
  final Insect insect;

  const InsectCard({Key? key, required this.insect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => InsectDetailsScreen(insect: insect)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.cardRadius),
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Hero(
                  tag: 'insect_${insect.name}',
                  child: CachedNetworkImage(
                    imageUrl: insect.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.bug_report,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insect.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insect.scientificName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textLightColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: [
                      if (insect.rnaInfo != null)
                        _buildTag(context, 'ARN', AppTheme.secondaryColor),
                      if (insect.nanoTechInfo != null)
                        _buildTag(context, 'Nano', AppTheme.accentColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class InsectDetailsScreen extends StatelessWidget {
  final Insect insect;

  const InsectDetailsScreen({
    Key? key,
    required this.insect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(insect.name),
              background: Hero(
                tag: 'insect_${insect.name}',
                child: CachedNetworkImage(
                  imageUrl: insect.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.bug_report,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insect.scientificName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    insect.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    'Características',
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: insect.characteristics.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.check_circle, color: AppTheme.primaryColor),
                          title: Text(insect.characteristics[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    context,
                    'Impacto',
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        insect.impact,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  if (insect.rnaInfo != null) ...[
                    const SizedBox(height: 24),
                    _buildExpandableSection(
                      context,
                      'Investigación de ARN',
                      _buildRNASection(context, insect.rnaInfo!),
                    ),
                  ],
                  if (insect.nanoTechInfo != null) ...[
                    const SizedBox(height: 24),
                    _buildExpandableSection(
                      context,
                      'Nanotecnología',
                      _buildNanoTechSection(context, insect.nanoTechInfo!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildExpandableSection(BuildContext context, String title, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildRNASection(BuildContext context, RNAInfo rnaInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rnaInfo.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        _buildSubSection(context, 'Aplicaciones', rnaInfo.applications),
        const SizedBox(height: 16),
        _buildSubSection(context, 'Hallazgos de Investigación', rnaInfo.researchFindings),
        if (rnaInfo.videoUrl != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Implementar reproducción de video
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Ver Video Explicativo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNanoTechSection(BuildContext context, NanoTechInfo nanoTechInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nanoTechInfo.description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        _buildSubSection(context, 'Aplicaciones', nanoTechInfo.applications),
        const SizedBox(height: 16),
        _buildSubSection(context, 'Innovaciones', nanoTechInfo.innovations),
        const SizedBox(height: 16),
        _buildSubSection(context, 'Perspectivas Futuras', nanoTechInfo.futureProspects),
        if (nanoTechInfo.imageUrl != null) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: nanoTechInfo.imageUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                Icons.arrow_right,
                color: AppTheme.secondaryColor,
              ),
              title: Text(items[index]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            );
          },
        ),
      ],
    );
  }
}
