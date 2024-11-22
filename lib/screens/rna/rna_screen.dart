import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tech_research_section.dart';
import '../../controllers/tech_research_controller.dart';
import '../../theme/app_theme.dart';

class RNAScreen extends StatelessWidget {
  const RNAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final techController = Get.put(TechResearchController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ARN y Control Biológico',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.calPolyGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Introducción al ARN',
              'El ARN (Ácido Ribonucleico) es una molécula fundamental en el control biológico de insectos. '
              'Su uso permite desarrollar métodos específicos y ecológicos para el control de plagas.',
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'ARN de Interferencia (RNAi)',
              'Tecnología que permite silenciar genes específicos en insectos plaga.',
              Icons.science,
            ),
            _buildInfoCard(
              'Ventajas del Control con ARN',
              '• Alta especificidad\n• Bajo impacto ambiental\n• Reducción de resistencia a insecticidas',
              Icons.check_circle,
            ),
            _buildInfoCard(
              'Aplicaciones Prácticas',
              '• Control de plagas en cultivos\n• Protección de granos almacenados\n• Manejo integrado de plagas',
              Icons.agriculture,
            ),
            const SizedBox(height: 20),
            _buildSection(
              'Proceso de Acción',
              '1. Identificación del gen objetivo\n'
              '2. Diseño de la molécula de ARN\n'
              '3. Aplicación en el cultivo\n'
              '4. Control específico de la plaga',
            ),
            const SizedBox(height: 30),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (techController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.calPolyGreen),
                  ),
                );
              }
              
              if (techController.researchInfo.value == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se pudo cargar la información',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.calPolyGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => techController.loadResearchInfo(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }
              
              return TechResearchSection(
                researchInfo: techController.researchInfo.value!,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D14), // Verde más oscuro para mejor contraste
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF333333), // Gris oscuro para mejor legibilidad
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.calPolyGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF317B22).withOpacity(0.1), // Verde más claro para el fondo del icono
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: const Color(0xFF317B22), // Verde más oscuro para el icono
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A4D14), // Verde más oscuro para mejor contraste
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF333333), // Gris oscuro para mejor legibilidad
              ),
            ),
          ],
        ),
      ),
    );
  }
}
