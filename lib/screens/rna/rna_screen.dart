import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../models/rna_content.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/language_selector.dart';

class RNAScreen extends StatelessWidget {
  const RNAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      drawer: BaseScreen.buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.calPolyGreen,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: const [
              LanguageSelector(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'rna_title'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'images/insects/control-biologico.jpeg',
                    fit: BoxFit.cover,
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: CustomPaint(
                      painter: HexagonPattern(),
                      size: Size.infinite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                child: Text(
                  'rna_intro_title'.tr,
                  style: const TextStyle(
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
            'rna_intro_description'.tr,
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                    content.title.tr,
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
                  content.description.tr,
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
                              point.tr,
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
              Text(
                'rna_crop_examples_title'.tr,
                style: const TextStyle(
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
              child: Image.asset(
                example.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  // Mostrar un icono como fallback si la imagen no se puede cargar
                  return Center(
                    child: Icon(
                      Icons.grass,
                      size: 64,
                      color: AppTheme.calPolyGreen,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
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
                  example.cropName.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'rna_crop_pest'.tr + ': ${example.targetPest.tr}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.officeGreen.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  example.description.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.officeGreen.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('rna_effectiveness'.tr, example.effectiveness.tr),
                _buildInfoRow('rna_implementation_process'.tr,
                    example.implementationProcess.tr),
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
