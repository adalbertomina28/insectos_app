import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../models/entomology_topic.dart';
import '../../widgets/language_selector.dart';
import '../../widgets/base_screen.dart';
import '../../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  final Key? key;
  const HomeScreen({this.key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final AuthController _authController = Get.find<AuthController>();

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: BaseScreen.buildDrawer(context),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header con la imagen del insecto
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          
          // Sección de características principales
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'main_features'.tr,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calPolyGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descubre las características más importantes de los insectos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Grid de características
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final features = [
                    {
                      'title': 'diverse_habitats'.tr,
                      'description': 'diverse_habitats_desc'.tr,
                      'icon': Icons.terrain,
                    },
                    {
                      'title': 'small_size'.tr,
                      'description': 'small_size_desc'.tr,
                      'icon': Icons.compress,
                    },
                    {
                      'title': 'segmented_body'.tr,
                      'description': 'segmented_body_desc'.tr,
                      'icon': Icons.view_week,
                    },
                    {
                      'title': 'chitin_exoskeleton'.tr,
                      'description': 'chitin_exoskeleton_desc'.tr,
                      'icon': Icons.shield,
                    },
                    {
                      'title': 'tracheal_respiration'.tr,
                      'description': 'tracheal_respiration_desc'.tr,
                      'icon': Icons.air,
                    },
                    {
                      'title': 'specialized_limbs'.tr,
                      'description': 'specialized_limbs_desc'.tr,
                      'icon': Icons.directions_walk,
                    }
                  ];

                  if (index >= features.length) return null;

                  final feature = features[index];
                  return _buildFeatureCard(
                    feature['title'].toString(),
                    feature['description'].toString(),
                    feature['icon'] as IconData,
                  );
                },
                childCount: 6,
              ),
            ),
          ),
          
          // Separador
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 1,
                color: Colors.grey[200],
              ),
            ),
          ),
          
          // Sección de temas de entomología
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'entomology_topics'.tr,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calPolyGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explora los temas más relevantes en el estudio de los insectos',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de temas de entomología
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildEntomologyContent(context),
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
                  ' ${DateTime.now().year} InsectLab • Digital Thinking'.tr,
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
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white,
            AppTheme.calPolyGreen.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Patrón de hexágonos sutiles en el fondo
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: CustomPaint(
                painter: HexagonPattern(),
              ),
            ),
          ),
          
          // Barra superior con menú y selector de idioma
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: AppTheme.calPolyGreen,
                        size: 28,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    const LanguageSelector(),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centrar todos los elementos
              children: [
                // Espacio para la barra superior
                const SizedBox(height: 100),
                
                // Imagen del insecto
                Image.asset(
                  'images/vectors/insecto_home.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 32),
                
                // Título principal
                Text(
                  'Insect Lab',
                  style: TextStyle(
                    color: AppTheme.calPolyGreen,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center, // Centrar el texto
                ),
                
                const SizedBox(height: 16),
                
                // Texto descriptivo
                Text(
                  'main_text'.tr,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center, // Centrar el texto
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 32),
                
                // Botón de explorar
                Center( // Centrar el botón
                  child: ElevatedButton(
                    onPressed: _scrollToFeatures,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'explore'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon,
      {VoidCallback? onTap}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppTheme.calPolyGreen, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Reducido el padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Asegurar que la columna use el mínimo espacio necesario
            children: [
              // Icono con fondo circular y color primario
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 12), // Reducido de 20 a 12
              // Título con estilo moderno
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16, // Reducido de 18 a 16
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8), // Reducido de 12 a 8
              // Descripción con estilo mejorado
              Text(
                description,
                style: TextStyle(
                  fontSize: 13, // Reducido de 14 a 13
                  color: Colors.black54,
                  height: 1.4, // Reducido de 1.5 a 1.4
                ),
                maxLines: 2, // Reducido de 3 a 2 líneas
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEntomologyContent(BuildContext context) {
    final topics = [
      EntomologyTopic(
        title: 'introduction_to_entomology'.tr,
        description: 'entomology_desc'.tr,
        content: [
          'insects_diverse'.tr,
          'insects_percentage'.tr,
          'insects_existence'.tr,
          'insects_ecosystems'.tr,
        ],
      ),
      EntomologyTopic(
        title: 'importance_in_agriculture'.tr,
        description: 'agriculture_desc'.tr,
        content: [
          'crop_pollination'.tr,
          'pest_control'.tr,
          'soil_health'.tr,
          'organic_decomposition'.tr,
        ],
      ),
      EntomologyTopic(
        title: 'anatomy_and_morphology'.tr,
        description: 'anatomy_desc'.tr,
        content: [
          'body_division'.tr,
          'legs'.tr,
          'wings'.tr,
          'chitin_exoskeleton'.tr,
        ],
      ),
    ];

    return topics.map((topic) => _buildTopicCard(context, topic)).toList();
  }

  // Diálogo de confirmación de cierre de sesión
  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400, // Limitar el ancho máximo
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // 90% del ancho en móvil
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de alerta
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red[700],
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  'logout_confirmation'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Mensaje
                Text(
                  'logout_message'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de cancelar
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón de cerrar sesión
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _authController.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'logout'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, EntomologyTopic topic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppTheme.calPolyGreen, width: 1.5),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(
            primary: AppTheme.primaryColor,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          iconColor: AppTheme.primaryColor,
          collapsedIconColor: AppTheme.primaryColor,
          backgroundColor: Colors.transparent,
          // Icono personalizado en el lado izquierdo
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bug_report,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          title: Text(
            topic.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              topic.description,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topic.content.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
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
