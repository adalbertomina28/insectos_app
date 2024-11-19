import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/encyclopedia/encyclopedia_screen.dart';
import 'screens/rna/rna_screen.dart';
import 'screens/key_insects/key_insects_screen.dart';
import 'screens/resources/resources_screen.dart';
import 'screens/entomology/entomology_screen.dart';
import 'screens/games/games_screen.dart';
import 'screens/games/game_play_screen.dart';
import 'screens/games/game_result_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const InsectosApp());
}

class InsectosApp extends StatelessWidget {
  const InsectosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Insectos App',
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/encyclopedia', page: () => EncyclopediaScreen()),
        GetPage(name: '/rna', page: () => const RNAScreen()),
        GetPage(name: '/key-insects', page: () => KeyInsectsScreen()),
        GetPage(name: '/resources', page: () => ResourcesScreen()),
        GetPage(name: '/entomology', page: () => EntomologyScreen()),
        GetPage(name: '/games', page: () => const GamesScreen()),
        GetPage(
          name: '/game-play',
          page: () => const GamePlayScreen(),
        ),
        GetPage(name: '/game-result', page: () => const GameResultScreen()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.green[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insectos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explora y aprende sobre insectos agrícolas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildMenuCard(
                        context,
                        'Entomología',
                        'Fundamentos y conceptos básicos',
                        Icons.school,
                        () => Get.to(() => EntomologyScreen()),
                      ),
                      _buildMenuCard(
                        context,
                        'Enciclopedia',
                        'Información detallada sobre insectos',
                        Icons.menu_book,
                        () => Get.to(() => EncyclopediaScreen()),
                      ),
                      _buildMenuCard(
                        context,
                        'ARN y Control',
                        'Tecnología de control biológico',
                        Icons.science,
                        () => Get.to(() => RNAScreen()),
                      ),
                      _buildMenuCard(
                        context,
                        'Insectos Clave',
                        'Especies de mayor impacto',
                        Icons.pest_control,
                        () => Get.to(() => KeyInsectsScreen()),
                      ),
                      _buildMenuCard(
                        context,
                        'Recursos',
                        'Material educativo adicional',
                        Icons.library_books,
                        () => Get.to(() => ResourcesScreen()),
                      ),
                      _buildMenuCard(
                        context,
                        'Juegos',
                        'Practica y aprende de manera divertida',
                        Icons.gamepad,
                        () => Get.to(() => const GamesScreen()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.green[50]!,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
