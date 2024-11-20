import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../models/entomology_topic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.0,
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Insectos',
                          style: TextStyle(
                            color: AppTheme.calPolyGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Explora el mundo de la entomología',
                          style: TextStyle(
                            color: AppTheme.officeGreen.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage('assets/images/home/header_bg.jpg'),
                            fit: BoxFit.cover,
                            filterQuality: MediaQuery.of(context).devicePixelRatio > 1.5
                                ? FilterQuality.high
                                : FilterQuality.medium,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.9),
                              Colors.white,
                            ],
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 48),
                          Text(
                            'Descubre la diversidad, comportamiento y el importante papel que juegan los insectos en nuestro ecosistema.',
                            style: TextStyle(
                              fontSize: 24,
                              color: AppTheme.officeGreen.withOpacity(0.8),
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 64),
                          ..._buildEntomologyContent(context),
                        ],
                      ),
                    ),
                    // Footer moderno
                    Container(
                      margin: const EdgeInsets.only(top: 80),
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                          ' ${DateTime.now().year} Insectos App • Desarrollado con ',
                          style: TextStyle(
                            color: AppTheme.officeGreen.withOpacity(0.6),
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                  const Text(
                    'Insectos App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
              icon: Icons.auto_stories,
              title: 'Enciclopedia',
              subtitle: 'Base de datos',
              onTap: () => Get.toNamed('/encyclopedia'),
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
              icon: Icons.school,
              title: 'Recursos',
              subtitle: 'Material educativo',
              onTap: () => Get.toNamed('/resources'),
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
      leading: Icon(icon, color: AppTheme.emerald),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppTheme.textSecondaryColor.withOpacity(0.8),
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  List<Widget> _buildEntomologyContent(BuildContext context) {
    final topics = [
      EntomologyTopic(
        title: 'Introducción a la Entomología',
        description: 'La entomología es la ciencia que estudia los insectos y su relación con el medio ambiente, los seres humanos y otros organismos.',
        content: [
          'Los insectos son la clase más diversa de animales en la Tierra',
          'Representan más del 80% de todas las especies animales conocidas',
          'Han existido por más de 350 millones de años',
          'Son fundamentales para la mayoría de los ecosistemas terrestres',
        ],
      ),
      EntomologyTopic(
        title: 'Importancia en la Agricultura',
        description: 'Los insectos juegan roles cruciales en la agricultura, tanto beneficiosos como perjudiciales.',
        content: [
          'Polinización de cultivos',
          'Control natural de plagas',
          'Mantenimiento de la salud del suelo',
          'Descomposición de materia orgánica',
        ],
      ),
      EntomologyTopic(
        title: 'Anatomía y Morfología',
        description: 'Características físicas y estructurales que definen a los insectos.',
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
          ...topic.content.map((item) => Padding(
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
          )).toList(),
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
    final double verticalSpacing = hexagonSize * 1.732; // aproximación de sqrt(3)

    for (double x = 0; x < size.width + hexagonSize; x += horizontalSpacing) {
      for (double y = 0; y < size.height + hexagonSize; y += verticalSpacing) {
        final double offsetX = (y ~/ verticalSpacing) % 2 == 0 ? 0 : horizontalSpacing / 2;
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
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.officeGreen.withOpacity(0.8),
            ),
          ),
        )).toList(),
      ],
    );
  }
}
