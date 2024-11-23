import 'package:flutter/material.dart';
import '../../models/insect.dart';
import '../../theme/app_theme.dart';

class InsectDetailScreen extends StatelessWidget {
  final Insect insect;

  const InsectDetailScreen({
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
              title: Text(
                insect.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.calPolyGreen,
                          AppTheme.officeGreen,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      insect.emoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection('Descripción', insect.description),
                  const SizedBox(height: 16),
                  _buildSection('Hábitat', insect.habitat),
                  const SizedBox(height: 16),
                  _buildSection('Comportamiento', insect.behavior),
                  const SizedBox(height: 16),
                  _buildSection('Alimentación', insect.diet),
                  const SizedBox(height: 16),
                  _buildSection('Ciclo de Vida', insect.lifecycle),
                  const SizedBox(height: 16),
                  _buildSection('Distribución', insect.distribution),
                  const SizedBox(height: 16),
                  _buildSection('Importancia Ecológica', insect.ecologicalRole),
                  if (insect.funFacts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Datos Curiosos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.calPolyGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...insect.funFacts.map((fact) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppTheme.calPolyGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fact,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                  const SizedBox(height: 32),
                  if (insect.conservationStatus.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.calPolyGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estado de Conservación',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.calPolyGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            insect.conservationStatus,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    if (content is List<String>) {
      if (content.isEmpty) return Container();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 8),
          ...content.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '• $item',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.officeGreen.withOpacity(0.8),
              ),
            ),
          )).toList(),
          const SizedBox(height: 16),
        ],
      );
    } else if (content is String && content.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.officeGreen.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    return Container();
  }
}
