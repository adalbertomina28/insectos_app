import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class KeyInsectsScreen extends StatelessWidget {
  KeyInsectsScreen({super.key});

  final List<Map<String, dynamic>> keyInsects = [
    {
      'name': 'Gusano Cogollero',
      'scientificName': 'Spodoptera frugiperda',
      'crops': ['Maíz', 'Sorgo', 'Algodón'],
      'importance': 'Plaga principal en cultivos de maíz en América Latina. Puede causar pérdidas de hasta el 70% en la producción.',
      'control': '• Control biológico con parasitoides\n• Manejo cultural\n• ARN interferente específico\n• Monitoreo temprano',
      'icon': Icons.pest_control,
      'emoji': '🐛',
    },
    {
      'name': 'Broca del Café',
      'scientificName': 'Hypothenemus hampei',
      'crops': ['Café'],
      'importance': 'Principal plaga del café a nivel mundial. Afecta directamente la calidad y rendimiento del grano.',
      'control': '• Control biológico con hongos\n• Trampas con feromonas\n• Manejo integrado\n• Control cultural',
      'icon': Icons.coffee,
      'emoji': '🪲',
    },
    {
      'name': 'Polilla del Tomate',
      'scientificName': 'Tuta absoluta',
      'crops': ['Tomate', 'Papa', 'Berenjena'],
      'importance': 'Causa daños severos en cultivos de solanáceas. Puede reducir el rendimiento hasta en un 80-100%.',
      'control': '• Control biológico\n• Monitoreo con feromonas\n• Manejo cultural\n• Rotación de cultivos',
      'icon': Icons.bug_report,
      'emoji': '🦋',
    },
    {
      'name': 'Mosca de la Fruta',
      'scientificName': 'Ceratitis capitata',
      'crops': ['Cítricos', 'Mango', 'Guayaba', 'Durazno'],
      'importance': 'Plaga cuarentenaria que afecta a una amplia variedad de frutas. Impacta el comercio internacional.',
      'control': '• Trampas con atrayentes\n• Control biológico\n• Manejo de residuos\n• Tratamiento en frío',
      'icon': Icons.pest_control,
      'emoji': '🪰',
    },
    {
      'name': 'Picudo del Algodón',
      'scientificName': 'Anthonomus grandis',
      'crops': ['Algodón'],
      'importance': 'Una de las plagas más destructivas del algodón. Puede causar pérdidas totales si no se controla.',
      'control': '• Monitoreo con feromonas\n• Control cultural\n• Destrucción de rastrojos\n• Control químico selectivo',
      'icon': Icons.bug_report,
      'emoji': '🪲',
    },
    {
      'name': 'Trips de las Flores',
      'scientificName': 'Frankliniella occidentalis',
      'crops': ['Flores', 'Hortalizas', 'Frutales'],
      'importance': 'Vector de virus importantes. Afecta la calidad estética y comercial de flores y frutos.',
      'control': '• Control biológico con ácaros\n• Manejo del riego\n• Trampas cromáticas\n• Eliminación de malezas',
      'icon': Icons.local_florist,
      'emoji': '🐜',
    },
    {
      'name': 'Gusano Barrenador',
      'scientificName': 'Diatraea saccharalis',
      'crops': ['Caña de Azúcar', 'Maíz', 'Sorgo'],
      'importance': 'Causa pérdidas significativas en cultivos de caña. Afecta el contenido de azúcar y el rendimiento.',
      'control': '• Control biológico\n• Variedades resistentes\n• Manejo de socas\n• Liberación de parasitoides',
      'icon': Icons.pest_control,
      'emoji': '🐛',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cardBackground = const Color(0xFF317B22);
    final customGreen = const Color(0xFF67E0A3);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Insectos Clave en Agricultura',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.calPolyGreen,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: keyInsects.length,
        itemBuilder: (context, index) {
          final insect = keyInsects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            color: cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                colorScheme: ColorScheme.dark(
                  primary: Colors.white,
                ),
              ),
              child: ExpansionTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      insect['emoji'] as String,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(
                  insect['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  insect['scientificName'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection(
                          'Cultivos Afectados',
                          (insect['crops'] as List<String>).join(', '),
                          Icons.agriculture,
                          Colors.white,
                          cardBackground,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Importancia',
                          insect['importance'] as String,
                          Icons.warning_amber,
                          Colors.white,
                          cardBackground,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(
                          'Métodos de Control',
                          insect['control'] as String,
                          Icons.security,
                          Colors.white,
                          cardBackground,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, Color textColor, Color backgroundColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: textColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
