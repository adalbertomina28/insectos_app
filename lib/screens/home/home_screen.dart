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
      drawer: BaseScreen.buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Selector de idioma
          const LanguageSelector(),
          // Botón de cierre de sesión
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(),
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 64, 48, 32),
              child: Text(
                'main_features'.tr,
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
            padding: const EdgeInsets.fromLTRB(
                24, 0, 24, 64), // Reducido el padding horizontal
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350, // Reducido de 400 a 350
                mainAxisSpacing: 16, // Reducido de 24 a 16
                crossAxisSpacing: 16, // Reducido de 24 a 16
                childAspectRatio:
                    1.5, // Aumentado de 1.2 a 1.5 para dar más espacio horizontal
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final features = [
                    /** {
                      'title': 'prediction'.tr,
                      'description': 'identify_insects'.tr,
                      'icon': Icons.camera_alt,
                    }, */
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
                    },
                    {
                      'title': 'varied_diet'.tr,
                      'description': 'varied_diet_desc'.tr,
                      'icon': Icons.restaurant_menu,
                    },
                    {
                      'title': 'metamorphosis'.tr,
                      'description': 'metamorphosis_desc'.tr,
                      'icon': Icons.change_circle,
                    },
                    {
                      'title': 'wings'.tr,
                      'description': 'wings_desc'.tr,
                      'icon': Icons.flight,
                    },
                    {
                      'title': 'social_behavior'.tr,
                      'description': 'social_behavior_desc'.tr,
                      'icon': Icons.groups,
                    },
                    {
                      'title': 'communication'.tr,
                      'description': 'communication_desc'.tr,
                      'icon': Icons.chat,
                    },
                    {
                      'title': 'ecological_impact'.tr,
                      'description': 'ecological_impact_desc'.tr,
                      'icon': Icons.eco,
                    },
                    {
                      'title': 'incredible_diversity'.tr,
                      'description': 'incredible_diversity_desc'.tr,
                      'icon': Icons.diversity_3,
                    },
                    {
                      'title': 'defensive_adaptations'.tr,
                      'description': 'defensive_adaptations_desc'.tr,
                      'icon': Icons.security,
                    },
                    {
                      'title': 'effective_reproduction'.tr,
                      'description': 'effective_reproduction_desc'.tr,
                      'icon': Icons.egg_alt,
                    },
                  ];

                  if (index >= features.length) return null;

                  final feature = features[index];
                  return _buildFeatureCard(
                    feature['title'] as String,
                    feature['description'] as String,
                    feature['icon'] as IconData,
                    onTap: index == 0
                        ? () => Get.toNamed('/identification')
                        : null,
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
        image: DecorationImage(
          image: AssetImage('images/home/home_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppTheme.calPolyGreen.withOpacity(0.7),
            BlendMode.overlay,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HexagonPattern(),
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
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
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
          // Contenido central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Insect Lab',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'main_text'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Reducido de 24 a 22
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _scrollToFeatures,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'explore'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calPolyGreen,
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
      elevation: 4,
      color: AppTheme.calPolyGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16), // Reducido de 24 a 16
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Ajusta el tamaño al mínimo necesario
            children: [
              Icon(
                icon,
                size: 28, // Reducido de 32 a 28
                color: Colors.white,
              ),
              const SizedBox(height: 12), // Reducido de 16 a 12
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18, // Reducido de 20 a 18
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6), // Reducido de 8 a 6
              Flexible(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13, // Reducido de 14 a 13
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
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
      AlertDialog(
        title: Text('logout_confirmation'.tr),
        content: Text('logout_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _authController.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, EntomologyTopic topic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          topic.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            topic.description,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topic.content.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
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
