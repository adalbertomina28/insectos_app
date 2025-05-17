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
      drawer: BaseScreen.buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          // Encabezado moderno con diseño similar al de la pantalla de inicio
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Barra superior con menú y selector de idioma
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: AppTheme.calPolyGreen,
                                size: 28,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                          const LanguageSelector(),
                        ],
                      ),
                    ),
                  ),
                  
                  // Espacio para la barra superior
                  const SizedBox(height: 16),
                  
                  // Imagen de ARN
                  Image.asset(
                    'images/vectors/arn.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {

                      return Container(
                        height: 180,
                        width: 180,
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.science,
                          size: 64,
                          color: AppTheme.calPolyGreen.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Título principal
                  Text(
                    'rna_title'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.calPolyGreen,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.calPolyGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.calPolyGreen.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                // Icono con fondo circular
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.calPolyGreen.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.science,
                    color: AppTheme.calPolyGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Título de la sección
                Expanded(
                  child: Text(
                    'rna_intro_title'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la sección
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'rna_intro_description'.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBasicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de la sección
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.calPolyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.calPolyGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'rna_basics_title'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        ...rnaBasics.map((content) => _buildContentCard(content)).toList(),
      ],
    );
  }

  Widget _buildContentCard(RNAContent content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.calPolyGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tarjeta
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.calPolyGreen.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono con fondo circular
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.calPolyGreen.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      content.iconData,
                      color: AppTheme.calPolyGreen,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Título
                Expanded(
                  child: Text(
                    content.title.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.description.tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // Puntos destacados
                ...content.bulletPoints.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Punto decorativo
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.calPolyGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Texto del punto
                        Expanded(
                          child: Text(
                            point.tr,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
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
        // Encabezado de la sección
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.calPolyGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.eco,
                  color: AppTheme.calPolyGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'rna_crop_examples_title'.tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // Lista de ejemplos de cultivos
        ...cropExamples.map((example) => _buildCropCard(example)),
      ],
    );
  }

  Widget _buildCropCard(RNACropExample example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.calPolyGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del cultivo
          Stack(
            children: [
              // Imagen con esquinas redondeadas
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Image.asset(
                    example.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {

                      return Center(
                        child: Icon(
                          Icons.grass,
                          size: 64,
                          color: AppTheme.calPolyGreen.withOpacity(0.5),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Gradiente sutil en la parte inferior de la imagen
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                ),
              ),
              // Nombre del cultivo sobre el gradiente
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  example.cropName.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Contenido de la tarjeta
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plaga objetivo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.calPolyGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'rna_crop_pest'.tr + ': ${example.targetPest.tr}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.calPolyGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Descripción
                Text(
                  example.description.tr,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                // Información adicional
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta con icono
          Row(
            children: [
              Icon(
                label.contains('effectiveness') ? Icons.trending_up : Icons.settings,
                size: 18,
                color: AppTheme.calPolyGreen,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Valor
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
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
