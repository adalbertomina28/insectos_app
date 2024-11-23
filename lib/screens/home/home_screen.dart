import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../models/entomology_topic.dart';
import '../games/games_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToFeatures() {
    _scrollController.animateTo(
      600, // Altura del header
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 600,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: AppTheme.emerald),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Fondo con el patrón de hexágonos
                      CustomPaint(
                        painter: HexagonPattern(),
                        size: Size.infinite,
                      ),
                      // Imagen de fondo con gradiente
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/insects/monarch_butterfly.jpg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Gradiente superior
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.calPolyGreen.withOpacity(0.95),
                              AppTheme.calPolyGreen.withOpacity(0.8),
                              AppTheme.officeGreen.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Patrón de hexágonos semitransparente
                      Opacity(
                        opacity: 0.1,
                        child: CustomPaint(
                          painter: HexagonPattern(),
                          size: Size.infinite,
                        ),
                      ),
                      // Contenido principal
                      Positioned(
                        left: 48,
                        right: 48,
                        bottom: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Descubre el fascinante\nmundo de los insectos',
                              style: TextStyle(
                                fontSize: 48,
                                height: 1.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -1,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Explora la diversidad, anatomía y comportamiento\nde los insectos en nuestra guía interactiva.',
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 48),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 600) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildActionButton(
                                        'Comenzar',
                                        Colors.white,
                                        AppTheme.calPolyGreen,
                                        _scrollToFeatures,
                                      ),
                                      SizedBox(height: 16),
                                      Builder(
                                        builder: (context) =>
                                            _buildActionButton(
                                          'Ver Guía',
                                          Colors.white,
                                          Colors.black87,
                                          () =>
                                              Scaffold.of(context).openDrawer(),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _buildActionButton(
                                        'Comenzar',
                                        Colors.white,
                                        AppTheme.calPolyGreen,
                                        _scrollToFeatures,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Builder(
                                        builder: (context) =>
                                            _buildActionButton(
                                          'Ver Guía',
                                          Colors.white,
                                          Colors.black87,
                                          () =>
                                              Scaffold.of(context).openDrawer(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 64, 48, 32),
                  child: Text(
                    'Características Principales',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calPolyGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(48, 0, 48, 64),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final features = [
                        {
                          'title': 'Hábitats diversos',
                          'description':
                              'Los insectos son extremadamente versátiles y pueden vivir en casi cualquier entorno terrestre, desde selvas tropicales hasta desiertos, y en ambientes acuáticos, como ríos y estanques.',
                          'icon': Icons.terrain,
                        },
                        {
                          'title': 'Tamaño pequeño',
                          'description':
                              'Su tamaño varía ampliamente, pero en general, los insectos son pequeños, lo que les permite aprovechar recursos que otros animales no pueden y esconderse fácilmente de depredadores.',
                          'icon': Icons.compress,
                        },
                        {
                          'title': 'Cuerpo segmentado',
                          'description':
                              'Su cuerpo está dividido en tres regiones principales: cabeza, tórax y abdomen, cada una con funciones específicas.',
                          'icon': Icons.view_week,
                        },
                        {
                          'title': 'Exoesqueleto de quitina',
                          'description':
                              'Este exoesqueleto protege a los insectos, les da soporte estructural y minimiza la pérdida de agua, siendo ideal para ambientes terrestres.',
                          'icon': Icons.shield,
                        },
                        {
                          'title': 'Respiración traqueal',
                          'description':
                              'Los insectos respiran a través de un sistema de tráqueas (tubos ramificados) que llevan oxígeno directamente a las células, lo que elimina la necesidad de un sistema circulatorio para el transporte de oxígeno.',
                          'icon': Icons.air,
                        },
                        {
                          'title': 'Extremidades especializadas',
                          'description':
                              'Sus patas están adaptadas a diferentes funciones según la especie, como caminar, correr, excavar, nadar o capturar presas.',
                          'icon': Icons.directions_walk,
                        },
                        {
                          'title': 'Alimentación variada',
                          'description':
                              'Los insectos tienen una dieta muy diversa, que incluye plantas, otros animales, materia en descomposición, y algunos incluso son parásitos. Su diversidad de piezas bucales refleja esta variedad alimenticia.',
                          'icon': Icons.restaurant_menu,
                        },
                        {
                          'title': 'Metamorfosis',
                          'description':
                              'Muchos insectos pasan por transformaciones en su ciclo de vida: metamorfosis completa (huevo → larva → pupa → adulto) o incompleta (huevo → ninfa → adulto).',
                          'icon': Icons.change_circle,
                        },
                        {
                          'title': 'Alas',
                          'description':
                              'Muchos insectos poseen alas, y son el único grupo de artrópodos que ha desarrollado vuelo verdadero, lo que les ha permitido colonizar nuevos hábitats.',
                          'icon': Icons.flight,
                        },
                        {
                          'title': 'Comportamientos sociales',
                          'description':
                              'Algunos insectos, como las abejas, hormigas y termitas, tienen sociedades altamente organizadas, con divisiones de trabajo y comunicación compleja.',
                          'icon': Icons.groups,
                        },
                        {
                          'title': 'Capacidad de comunicación',
                          'description':
                              'Los insectos se comunican utilizando señales químicas (feromonas), visuales (movimientos o colores) y sonoras (como el canto de los grillos).',
                          'icon': Icons.chat,
                        },
                        {
                          'title': 'Impacto ecológico',
                          'description':
                              'Desempeñan roles esenciales en los ecosistemas, como polinizadores, descomponedores y controladores de poblaciones de otros organismos.',
                          'icon': Icons.eco,
                        },
                        {
                          'title': 'Diversidad increíble',
                          'description':
                              'Con más de un millón de especies descritas y posiblemente millones más sin descubrir, los insectos son el grupo más diverso del reino animal.',
                          'icon': Icons.diversity_3,
                        },
                        {
                          'title': 'Adaptaciones defensivas',
                          'description':
                              'Incluyen camuflaje, colores aposemáticos (de advertencia), venenos y comportamientos como hacerse el muerto para evitar depredadores.',
                          'icon': Icons.security,
                        },
                        {
                          'title': 'Reproducción eficaz',
                          'description':
                              'Su capacidad para poner grandes cantidades de huevos asegura la supervivencia de la especie, incluso bajo condiciones adversas.',
                          'icon': Icons.egg_alt,
                        },
                      ];

                      if (index >= features.length) return null;

                      final feature = features[index];
                      return Card(
                        elevation: 2,
                        color: AppTheme.celadon.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    feature['icon'] as IconData,
                                    color: AppTheme.calPolyGreen,
                                    size: 28,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      feature['title'] as String,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.calPolyGreen,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    feature['description'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: 16,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: AppTheme.calPolyGreen.withOpacity(0.05),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.calPolyGreen.withOpacity(0.05),
                        offset: const Offset(0, -2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      ' ${DateTime.now().year} InsectLab • Digital Thinking',
                      style: TextStyle(
                        color: AppTheme.officeGreen.withOpacity(0.6),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppTheme.calPolyGreen,
            width: bgColor == Colors.white ? 2 : 0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.calPolyGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.calPolyGreen,
              size: 24,
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.calPolyGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.calPolyGreen,
                    AppTheme.officeGreen,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '🐝',
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Insect Lab',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Educación Entomológica',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.search,
              title: 'Busqueda de insectos',
              subtitle: 'Base de datos',
              onTap: () => Get.toNamed('/insect-search'),
            ),
            _buildDrawerItem(
              icon: Icons.science,
              title: 'ARN',
              subtitle: 'Control biológico',
              onTap: () => Get.toNamed('/rna'),
            ),
            _buildDrawerItem(
              icon: Icons.pest_control,
              title: 'Insectos Clave',
              subtitle: 'Especies importantes',
              onTap: () => Get.toNamed('/key-insects'),
            ),
            _buildDrawerItem(
              icon: Icons.games,
              title: 'Juegos Educativos',
              subtitle: 'Aprende jugando',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GamesMenuScreen(),
                  ),
                );
              },
            ),
            const Divider(color: AppTheme.emerald),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'Acerca de',
              subtitle: 'Nuestra misión',
              onTap: () => Get.toNamed('/about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.calPolyGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppTheme.calPolyGreen,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.calPolyGreen,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 13,
        ),
      ),
      onTap: onTap,
    );
  }

  List<Widget> _buildEntomologyContent(BuildContext context) {
    final topics = [
      EntomologyTopic(
        title: 'Introducción a la Entomología',
        description:
            'La entomología es la ciencia que estudia los insectos y su relación con el medio ambiente, los seres humanos y otros organismos.',
        content: [
          'Los insectos son la clase más diversa de animales en la Tierra',
          'Representan más del 80% de todas las especies animales conocidas',
          'Han existido por más de 350 millones de años',
          'Son fundamentales para la mayoría de los ecosistemas terrestres',
        ],
      ),
      EntomologyTopic(
        title: 'Importancia en la Agricultura',
        description:
            'Los insectos juegan roles cruciales en la agricultura, tanto beneficiosos como perjudiciales.',
        content: [
          'Polinización de cultivos',
          'Control natural de plagas',
          'Mantenimiento de la salud del suelo',
          'Descomposición de materia orgánica',
        ],
      ),
      EntomologyTopic(
        title: 'Anatomía y Morfología',
        description:
            'Características físicas y estructurales que definen a los insectos.',
        content: [
          'División del cuerpo en cabeza, tórax y abdomen',
          'Presencia de tres pares de patas',
          'Un par o dos pares de alas en la mayoría de especies',
          'Exoesqueleto de quitina',
        ],
      ),
    ];

    return topics.map((topic) => _buildTopicCard(context, topic)).toList();
  }

  Widget _buildTopicCard(BuildContext context, EntomologyTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80), // Más espacio entre secciones
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.title,
            style: const TextStyle(
              fontSize: 32, // Título más grande
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.emerald,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            topic.description,
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.officeGreen.withOpacity(0.8),
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 32),
          ...topic.content
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.emerald,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.officeGreen.withOpacity(0.8),
                              height: 1.6,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}

class HexagonPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.calPolyGreen.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double hexagonSize = 30;
    const double horizontalSpacing = hexagonSize * 1.5;
    final double verticalSpacing =
        hexagonSize * 1.732; // aproximación de sqrt(3)

    for (double x = 0; x < size.width + hexagonSize; x += horizontalSpacing) {
      for (double y = 0; y < size.height + hexagonSize; y += verticalSpacing) {
        final double offsetX =
            (y ~/ verticalSpacing) % 2 == 0 ? 0 : horizontalSpacing / 2;
        final path = Path();
        for (int i = 0; i < 6; i++) {
          final double angle = (i * 60) * math.pi / 180;
          final double nextAngle = ((i + 1) * 60) * math.pi / 180;
          if (i == 0) {
            path.moveTo(
              x + offsetX + hexagonSize * math.cos(angle),
              y + hexagonSize * math.sin(angle),
            );
          }
          path.lineTo(
            x + offsetX + hexagonSize * math.cos(nextAngle),
            y + hexagonSize * math.sin(nextAngle),
          );
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Widget para las secciones del footer
class _FooterSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.calPolyGreen,
          ),
        ),
        const SizedBox(height: 12),
        ...items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.officeGreen.withOpacity(0.8),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
