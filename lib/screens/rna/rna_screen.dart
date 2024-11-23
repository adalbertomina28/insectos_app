import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';
import '../../models/rna_content.dart';

class RNAScreen extends StatelessWidget {
  const RNAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.calPolyGreen,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'ARN y Control Biológico',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
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
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: CustomPaint(
                      painter: HexagonPattern(),
                      size: Size.infinite,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.biotech_outlined,
                          size: 64,
                          color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroSection(),
                  const SizedBox(height: 32),
                  _buildBasicsSection(),
                  const SizedBox(height: 32),
                  _buildCropExamplesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppTheme.celadon.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.calPolyGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.calPolyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.science,
                  color: AppTheme.calPolyGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: const Text(
                  'Tecnología Revolucionaria',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'El control biológico mediante ARN representa una revolución en la protección de cultivos, '
            'ofreciendo soluciones específicas y sostenibles para el manejo de plagas.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.officeGreen.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rnaBasics.map((content) => _buildContentCard(content)).toList(),
    );
  }

  Widget _buildContentCard(RNAContent content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.calPolyGreen.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: AppTheme.celadon.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.calPolyGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    content.iconData,
                    color: AppTheme.calPolyGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.calPolyGreen,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.officeGreen.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                ...content.bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppTheme.emerald,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.officeGreen.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropExamplesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.calPolyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.eco,
                  color: AppTheme.calPolyGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Ejemplos en Cultivos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.calPolyGreen,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...cropExamples.map((example) => _buildCropCard(example)),
      ],
    );
  }

  Widget _buildCropCard(RNACropExample example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.calPolyGreen.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.celadon.withOpacity(0.3),
              child: Center(
                child: Icon(
                  Icons.grass,
                  size: 64,
                  color: AppTheme.calPolyGreen,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.calPolyGreen.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example.cropName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Plaga objetivo: ${example.targetPest}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.officeGreen.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  example.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.officeGreen.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Efectividad:', example.effectiveness),
                _buildInfoRow('Proceso:', example.implementationProcess),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.officeGreen.withOpacity(0.8),
              height: 1.5,
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
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double hexagonSize = 30;
    const double horizontalSpacing = hexagonSize * 1.5;
    final double verticalSpacing = hexagonSize * 1.732;

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
