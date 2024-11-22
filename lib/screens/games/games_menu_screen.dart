import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import 'memory_game_screen.dart';
import 'lifecycle_game_screen.dart';
import 'classification_game_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos Educativos'),
        backgroundColor: AppTheme.calPolyGreen,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildGameCard(
            title: 'Juego de Memoria',
            description: 'Encuentra pares de insectos y aprende sobre sus características.',
            emoji: '🎴',
            onTap: () => Get.to(() => const MemoryGameScreen()),
          ),
          const SizedBox(height: 20),
          _buildGameCard(
            title: 'Ciclo de Vida',
            description: 'Ordena las etapas del ciclo de vida de diferentes insectos.',
            emoji: '🦋',
            onTap: () => Get.to(() => const LifecycleGameScreen()),
          ),
          const SizedBox(height: 20),
          _buildGameCard(
            title: 'Clasificación',
            description: 'Aprende a clasificar insectos según sus características como tipo de alas, antenas y metamorfosis.',
            emoji: '🐝',
            onTap: () => Get.to(() => const ClassificationGameScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String description,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.calPolyGreen.withOpacity(0.1),
            AppTheme.calPolyGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.calPolyGreen.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.calPolyGreen.withOpacity(0.9),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87.withOpacity(0.6),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.calPolyGreen.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
