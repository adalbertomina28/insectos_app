import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import '../../models/insect.dart';
import '../../theme/app_theme.dart';
import 'package:insectos_app/widgets/hexagon_pattern.dart';

class EncyclopediaController extends GetxController {
  final RxList<Insect> filteredInsects = <Insect>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Todos'.obs;
  final RxString selectedFilter = 'Categoría'.obs;
  final RxList<String> selectedValues = <String>[].obs;
  final RxBool isLoading = false.obs;

  // Filtros disponibles
  final List<String> filterTypes = [
    'Categoría',
    'Hábitat',
    'Dieta',
    'Actividad',
    'Ciclo de Vida'
  ];

  // Valores para cada tipo de filtro
  final Map<String, List<String>> filterValues = {
    'Categoría': ['Todos', 'Benéficos', 'Plagas', 'Polinizadores'],
    'Hábitat': ['Todos', 'Terrestre', 'Acuático', 'Subterráneo'],
    'Dieta': ['Todos', 'Herbívoro', 'Carnívoro', 'Omnívoro'],
    'Actividad': ['Todos', 'Diurno', 'Nocturno', 'Crepuscular'],
    'Ciclo de Vida': ['Todos', 'Huevo', 'Larva', 'Pupa', 'Adulto'],
  };
  
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
      categories: ['Polinizadores', 'Benéficos'],
      habitat: ['Terrestre'],
      size: '8.9-10.2 cm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['América del Norte', 'América Central'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
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
      ),
      nanoTechInfo: NanoTechInfo(
        description: 'La estructura de las alas de la mariposa monarca ha inspirado desarrollos en nanotecnología.',
        applications: [
          'Desarrollo de paneles solares más eficientes',
          'Creación de superficies hidrofóbicas',
          'Diseño de sensores ambientales',
        ],
        innovations: [
          'Nanopartículas inspiradas en las escamas de las alas',
          'Superficies autolimpiantes basadas en la nanoestructura',
          'Sistemas fotónicos bioinspirados',
        ],
      ),
    ),
    Insect(
      name: 'Abeja Melífera',
      scientificName: 'Apis mellifera',
      description: 'La abeja melífera es crucial para la polinización y la producción de miel. Vive en colonias altamente organizadas.',
      imageUrl: 'assets/images/insects/honey_bee.jpg',
      characteristics: [
        'Cuerpo rayado negro y amarillo',
        'Pelos especializados para recolectar polen',
        'Aguijón defensivo',
      ],
      impact: 'Vital para la polinización de cultivos y la producción de miel.',
      categories: ['Polinizadores', 'Benéficos'],
      habitat: ['Terrestre'],
      size: '1.2-1.5 cm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Gorgojo del Maíz',
      scientificName: 'Sitophilus zeamais',
      description: 'Pequeño escarabajo que afecta principalmente al maíz almacenado.',
      imageUrl: 'assets/images/insects/maize_weevil.jpg',
      characteristics: [
        'Color marrón oscuro a negro',
        'Rostro alargado característico',
        'Élitros con puntuaciones',
      ],
      impact: 'Causa pérdidas significativas en granos almacenados.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '2.5-4 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Catarina',
      scientificName: 'Coccinella septempunctata',
      description: 'Pequeño escarabajo conocido por alimentarse de plagas como los pulgones.',
      imageUrl: 'assets/images/insects/ladybug.jpg',
      characteristics: [
        'Color rojo con puntos negros',
        'Forma semiesférica',
        'Élitros protectores',
      ],
      impact: 'Control biológico natural de plagas.',
      categories: ['Benéficos'],
      habitat: ['Terrestre'],
      size: '5-8 mm',
      diet: ['Carnívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Mantis Religiosa',
      scientificName: 'Mantis religiosa',
      description: 'Depredador eficiente que se camufla entre la vegetación.',
      imageUrl: 'assets/images/insects/praying_mantis.jpg',
      characteristics: [
        'Patas delanteras raptoras',
        'Cabeza triangular móvil',
        'Color verde o marrón',
      ],
      impact: 'Control natural de plagas en jardines y cultivos.',
      categories: ['Benéficos'],
      habitat: ['Terrestre'],
      size: '5-7.5 cm',
      diet: ['Carnívoro'],
      activity: ['Diurno', 'Crepuscular'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Mosca de la Fruta',
      scientificName: 'Drosophila melanogaster',
      description: 'Pequeña mosca que afecta frutas maduras y fermentadas.',
      imageUrl: 'assets/images/insects/fruit_fly.jpg',
      characteristics: [
        'Ojos rojos brillantes',
        'Cuerpo amarillento',
        'Alas transparentes',
      ],
      impact: 'Puede dañar frutas y productos almacenados.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '3-4 mm',
      diet: ['Omnívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
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
      impact: 'Vector de más de 100 virus de plantas. Reduce significativamente el rendimiento de cultivos.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '1-2 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Gusano Cogollero',
      scientificName: 'Spodoptera frugiperda',
      description: 'Lepidóptero que ataca principalmente al maíz y otros cultivos de gramíneas.',
      imageUrl: 'assets/images/insects/fall_armyworm.jpg',
      characteristics: [
        'Larva: 35-40mm',
        'Color variable, desde verde hasta café oscuro',
        'Marca en Y invertida en la cabeza',
        'Adulto: polilla de color gris-café'
      ],
      impact: 'Puede causar pérdidas totales en cultivos de maíz y otros cereales.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '35-40 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Trips de las Flores',
      scientificName: 'Frankliniella occidentalis',
      description: 'Pequeño insecto que afecta principalmente a flores y frutos.',
      imageUrl: 'assets/images/insects/western_flower_thrips.jpg',
      characteristics: [
        'Longitud: 1-1.5mm',
        'Color amarillento a marrón',
        'Alas con flecos característicos',
        'Aparato bucal raspador-chupador'
      ],
      impact: 'Transmite virus y afecta la calidad estética de flores y frutos.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '1-1.5 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Pulgón Verde',
      scientificName: 'Myzus persicae',
      description: 'Áfido polífago que afecta a numerosos cultivos.',
      imageUrl: 'assets/images/insects/green_peach_aphid.jpg',
      characteristics: [
        'Longitud: 1.2-2.1mm',
        'Color verde claro a rosado',
        'Sifones largos y oscuros',
        'Formas aladas y ápteras'
      ],
      impact: 'Vector de virus y daños por succión de savia.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '1.2-2.1 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Gallina Ciega',
      scientificName: 'Phyllophaga spp.',
      description: 'Larva de escarabajo que ataca raíces de diversos cultivos.',
      imageUrl: 'assets/images/insects/white_grub.jpg',
      characteristics: [
        'Larva: 20-30mm',
        'Color blanco cremoso',
        'Cabeza café rojiza',
        'Cuerpo en forma de "C"'
      ],
      impact: 'Daña severamente sistemas radiculares de cultivos.',
      categories: ['Plagas'],
      habitat: ['Subterráneo'],
      size: '20-30 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Picudo del Chile',
      scientificName: 'Anthonomus eugenii',
      description: 'Pequeño curculiónido específico del chile.',
      imageUrl: 'assets/images/insects/pepper_weevil.jpg',
      characteristics: [
        'Adulto: 2-3.5mm',
        'Color negro a gris oscuro',
        'Rostro largo y curvo',
        'Élitros con pubescencia'
      ],
      impact: 'Causa pérdidas significativas en cultivos de chile.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '2-3.5 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Gusano del Cuerno',
      scientificName: 'Manduca sexta',
      description: 'Gran lepidóptero que afecta a plantas solanáceas.',
      imageUrl: 'assets/images/insects/tobacco_hornworm.jpg',
      characteristics: [
        'Larva: hasta 100mm',
        'Color verde brillante',
        'Cuerno posterior característico',
        'Franjas laterales blancas y negras'
      ],
      impact: 'Defoliador importante en cultivos de tomate y tabaco.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '100 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Araña Roja',
      scientificName: 'Tetranychus urticae',
      description: 'Ácaro fitófago que afecta a numerosos cultivos.',
      imageUrl: 'assets/images/insects/red_spider_mite.jpg',
      characteristics: [
        'Longitud: 0.4-0.5mm',
        'Color variable, rojizo a verdoso',
        'Manchas oscuras dorsales',
        'Produce telarañas características'
      ],
      impact: 'Reduce la capacidad fotosintética y causa defoliación.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '0.4-0.5 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Barrenador del Tallo',
      scientificName: 'Diatraea saccharalis',
      description: 'Lepidóptero que barrena tallos de gramíneas.',
      imageUrl: 'assets/images/insects/sugarcane_borer.jpg',
      characteristics: [
        'Larva: 25-30mm',
        'Color crema con puntos oscuros',
        'Cabeza marrón',
        'Adulto: polilla color paja'
      ],
      impact: 'Reduce el rendimiento y calidad de la caña de azúcar.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '25-30 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Chinche Verde',
      scientificName: 'Nezara viridula',
      description: 'Hemíptero que afecta a leguminosas y otros cultivos.',
      imageUrl: 'assets/images/insects/green_stink_bug.jpg',
      characteristics: [
        'Longitud: 14-16mm',
        'Color verde brillante',
        'Forma de escudo',
        'Antenas segmentadas'
      ],
      impact: 'Daña directamente frutos y semillas de cultivos.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '14-16 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Minador de la Hoja',
      scientificName: 'Liriomyza spp.',
      description: 'Pequeña mosca cuyas larvas crean galerías en las hojas.',
      imageUrl: 'assets/images/insects/leafminer.jpg',
      characteristics: [
        'Adulto: 2-3mm',
        'Color negro con amarillo',
        'Larvas: ápodas y amarillentas',
        'Minas serpenteantes características'
      ],
      impact: 'Reduce la capacidad fotosintética de las plantas.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '2-3 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Palomilla Dorso de Diamante',
      scientificName: 'Plutella xylostella',
      description: 'Microlepidóptero específico de crucíferas.',
      imageUrl: 'assets/images/insects/diamondback_moth.jpg',
      characteristics: [
        'Adulto: 8-10mm',
        'Patrón dorsal en forma de diamantes',
        'Larvas verde claro',
        'Alta resistencia a insecticidas'
      ],
      impact: 'Causa pérdidas significativas en cultivos de crucíferas.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '8-10 mm',
      diet: ['Herbívoro'],
      activity: ['Nocturno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Larva', 'Pupa', 'Adulto'],
    ),
    Insect(
      name: 'Trips del Aguacate',
      scientificName: 'Scirtothrips perseae',
      description: 'Pequeño insecto específico del aguacate.',
      imageUrl: 'assets/images/insects/avocado_thrips.jpg',
      characteristics: [
        'Adulto: 1mm',
        'Color amarillo pálido',
        'Alas con flecos',
        'Alta movilidad'
      ],
      impact: 'Causa deformaciones en frutos jóvenes de aguacate.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '1 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['América'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
    Insect(
      name: 'Escama Armada',
      scientificName: 'Quadraspidiotus perniciosus',
      description: 'Insecto escama que afecta principalmente a frutales.',
      imageUrl: 'assets/images/insects/san_jose_scale.jpg',
      characteristics: [
        'Hembra: 2mm diámetro',
        'Escama circular gris',
        'Macho alado diminuto',
        'Ninfas móviles inicialmente'
      ],
      impact: 'Debilita árboles frutales y puede causar su muerte.',
      categories: ['Plagas'],
      habitat: ['Terrestre'],
      size: '2 mm',
      diet: ['Herbívoro'],
      activity: ['Diurno'],
      distribution: ['Mundial'],
      lifecycle: ['Huevo', 'Ninfa', 'Adulto'],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    filteredInsects.assignAll(allInsects);
  }

  void filterInsects() {
    List<Insect> results = allInsects;
    
    // Filtrar por búsqueda
    if (searchQuery.value.isNotEmpty) {
      results = results.where((insect) {
        return insect.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            insect.scientificName.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    // Filtrar por valores seleccionados
    if (selectedValues.isNotEmpty && selectedFilter.value != 'Categoría') {
      results = results.where((insect) {
        switch (selectedFilter.value) {
          case 'Hábitat':
            return selectedValues.any((value) => insect.habitat.contains(value));
          case 'Dieta':
            return selectedValues.any((value) => insect.diet.contains(value));
          case 'Actividad':
            return selectedValues.any((value) => insect.activity.contains(value));
          case 'Ciclo de Vida':
            return selectedValues.any((value) => insect.lifecycle.contains(value));
          default:
            return true;
        }
      }).toList();
    } else if (selectedCategory.value != 'Todos') {
      results = results.where((insect) => 
        insect.categories.contains(selectedCategory.value)
      ).toList();
    }

    filteredInsects.assignAll(results);
  }

  void changeFilter(String filterType) {
    selectedFilter.value = filterType;
    selectedValues.clear();
    if (filterType == 'Categoría') {
      selectedCategory.value = 'Todos';
    }
    filterInsects();
  }

  void toggleFilterValue(String value) {
    if (value == 'Todos') {
      selectedValues.clear();
    } else {
      if (selectedValues.contains(value)) {
        selectedValues.remove(value);
      } else {
        selectedValues.add(value);
      }
    }
    filterInsects();
  }
}

class EncyclopediaScreen extends GetView<EncyclopediaController> {
  EncyclopediaScreen({Key? key}) : super(key: key) {
    Get.put(EncyclopediaController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/monarch_butterfly.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              toolbarHeight: 60,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enciclopedia',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Explora nuestra colección de insectos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppTheme.calPolyGreen,
                        AppTheme.officeGreen,
                        AppTheme.emerald,
                      ],
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Patrón de fondo
                      CustomPaint(
                        painter: HexagonPattern(color: Colors.white.withOpacity(0.05)),
                        size: Size.infinite,
                      ),
                      // Ícono decorativo
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: Icon(
                            Icons.science_outlined,
                            size: 200,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Ícono secundario
                      Positioned(
                        left: -10,
                        top: 20,
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Icon(
                            Icons.catching_pokemon_outlined,
                            size: 120,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de búsqueda
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar insectos...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.calPolyGreen,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          controller.searchQuery.value = value;
                          controller.filterInsects();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Título de filtros
                    Text(
                      'Filtrar por:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.calPolyGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filtros principales
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.filterTypes.map((filterType) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Obx(() {
                              final isSelected = controller.selectedFilter.value == filterType;
                              return FilterChip(
                                label: Text(filterType),
                                selected: isSelected,
                                selectedColor: AppTheme.emerald.withOpacity(0.2),
                                checkmarkColor: AppTheme.calPolyGreen,
                                labelStyle: TextStyle(
                                  color: isSelected ? AppTheme.calPolyGreen : Colors.grey[600],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? AppTheme.emerald : Colors.grey[300]!,
                                  ),
                                ),
                                onSelected: (selected) {
                                  controller.changeFilter(filterType);
                                },
                              );
                            }),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Valores de filtro
                    Obx(() {
                      if (controller.selectedFilter.value == 'Categoría') {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.filterValues['Categoría']!.map((value) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Obx(() {
                                  final isSelected = controller.selectedCategory.value == value;
                                  return FilterChip(
                                    label: Text(value),
                                    selected: isSelected,
                                    selectedColor: AppTheme.emerald.withOpacity(0.2),
                                    checkmarkColor: AppTheme.calPolyGreen,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppTheme.calPolyGreen : Colors.grey[600],
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: isSelected ? AppTheme.emerald : Colors.grey[300]!,
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      controller.selectedCategory.value = value;
                                      controller.filterInsects();
                                    },
                                  );
                                }),
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.filterValues[controller.selectedFilter.value]!.map((value) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Obx(() {
                                  final isSelected = controller.selectedValues.contains(value);
                                  return FilterChip(
                                    label: Text(value),
                                    selected: isSelected,
                                    selectedColor: AppTheme.emerald.withOpacity(0.2),
                                    checkmarkColor: AppTheme.calPolyGreen,
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppTheme.calPolyGreen : Colors.grey[600],
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: isSelected ? AppTheme.emerald : Colors.grey[300]!,
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      controller.toggleFilterValue(value);
                                    },
                                  );
                                }),
                              );
                            }).toList(),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            Obx(() {
              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final insect = controller.filteredInsects[index];
                      return Hero(
                        tag: 'insect-${insect.name}',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navegar al detalle del insecto
                                Get.toNamed('/insect-detail/${insect.name}');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(insect.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              insect.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              insect.scientificName,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.category_outlined,
                                                  size: 16,
                                                  color: AppTheme.calPolyGreen,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    insect.categories.join(', '),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: controller.filteredInsects.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                ),
              );
            }),
          ],
        ),
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Hero(
                  tag: 'insect_${insect.name}',
                  child: Image.asset(
                    insect.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.bug_report,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
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
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...insect.categories.map((category) => _buildTag(context, category, Colors.blue)),
                      if (insect.habitat.isNotEmpty)
                        _buildTag(context, insect.habitat.first, Colors.green),
                      if (insect.diet.isNotEmpty)
                        _buildTag(context, insect.diet.first, Colors.orange),
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

  const InsectDetailsScreen({Key? key, required this.insect}) : super(key: key);

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
                child: Image.asset(
                  insect.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.bug_report,
                      size: 40,
                      color: Colors.grey[400],
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
                  _buildSection(context, 'Características', insect.characteristics),
                  const SizedBox(height: 16),
                  if (insect.habitat.isNotEmpty) ...[
                    _buildSection(context, 'Hábitat', insect.habitat),
                    const SizedBox(height: 16),
                  ],
                  if (insect.diet.isNotEmpty) ...[
                    _buildSection(context, 'Dieta', insect.diet),
                    const SizedBox(height: 16),
                  ],
                  if (insect.activity.isNotEmpty) ...[
                    _buildSection(context, 'Actividad', insect.activity),
                    const SizedBox(height: 16),
                  ],
                  if (insect.lifecycle.isNotEmpty) ...[
                    _buildSection(context, 'Ciclo de Vida', insect.lifecycle),
                    const SizedBox(height: 16),
                  ],
                  _buildSection(context, 'Impacto', [insect.impact]),
                  if (insect.rnaInfo != null || insect.nanoTechInfo != null) ...[
                    const SizedBox(height: 24),
                    _buildResearchSection(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildResearchSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investigación',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (insect.rnaInfo != null)
          _buildResearchCard(
            context,
            'ARN',
            insect.rnaInfo!.description,
            insect.rnaInfo!.applications,
          ),
        if (insect.nanoTechInfo != null) ...[
          const SizedBox(height: 16),
          _buildResearchCard(
            context,
            'Nanotecnología',
            insect.nanoTechInfo!.description,
            insect.nanoTechInfo!.applications,
          ),
        ],
      ],
    );
  }

  Widget _buildResearchCard(
    BuildContext context,
    String title,
    String description,
    List<String> applications,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Aplicaciones:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...applications.map((app) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.arrow_right, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(app),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
