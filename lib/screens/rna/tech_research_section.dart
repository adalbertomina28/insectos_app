import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/tech_research_info.dart';
import '../../theme/app_theme.dart';

class ResourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? url;
  final Color color;

  const ResourceButton({
    Key? key,
    required this.icon,
    required this.label,
    this.url,
    this.color = const Color(0xFF2196F3),
  }) : super(key: key);

  Future<void> _launchUrl() async {
    if (url == null) return;
    
    final Uri uri = Uri.parse(url!);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo abrir el enlace',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: url != null ? _launchUrl : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class TechResearchSection extends StatelessWidget {
  final TechResearchInfo researchInfo;

  const TechResearchSection({
    Key? key,
    required this.researchInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildDescription(),
        const SizedBox(height: 24),
        _buildAdvances(),
        const SizedBox(height: 24),
        _buildBenefits(),
        const SizedBox(height: 24),
        _buildFutureProspects(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          researchInfo.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D14),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Avances Tecnológicos en Entomología',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      researchInfo.description,
      style: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildAdvances() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avances Recientes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D14),
          ),
        ),
        const SizedBox(height: 16),
        ...researchInfo.advances.map(
          (advance) => _buildAdvanceCard(advance),
        ),
      ],
    );
  }

  Widget _buildAdvanceCard(ResearchAdvance advance) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: const Color(0xFF317B22).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.science,
                    size: 24,
                    color: Color(0xFF317B22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        advance.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A4D14),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        advance.date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              advance.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (advance.resourceUrl != null)
                    ResourceButton(
                      icon: Icons.article_outlined,
                      label: 'Leer más',
                      url: advance.resourceUrl,
                      color: AppTheme.primaryColor,
                    ),
                  if (advance.videoUrl != null)
                    ResourceButton(
                      icon: Icons.play_circle_outline,
                      label: 'Ver video',
                      url: advance.videoUrl,
                      color: Colors.red,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beneficios y Aplicaciones',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D14),
          ),
        ),
        const SizedBox(height: 16),
        ...researchInfo.benefits.map(
          (benefit) => _buildBenefitCard(benefit),
        ),
      ],
    );
  }

  Widget _buildBenefitCard(TechnologyBenefit benefit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: const Color(0xFF317B22).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    size: 24,
                    color: Color(0xFF317B22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    benefit.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A4D14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              benefit.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
            if (benefit.learnMoreUrl != null) ...[
              const SizedBox(height: 16),
              ResourceButton(
                icon: Icons.open_in_new,
                label: 'Explorar más',
                url: benefit.learnMoreUrl,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFutureProspects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perspectivas Futuras',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A4D14),
          ),
        ),
        const SizedBox(height: 16),
        ...researchInfo.futureProspects.map(
          (prospect) => Card(
            margin: const EdgeInsets.only(bottom: 16),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF317B22).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      size: 24,
                      color: Color(0xFF317B22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prospect,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
