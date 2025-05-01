import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';

class KeyInsectsScreen extends StatelessWidget {
  KeyInsectsScreen({super.key});

  final List<Map<String, dynamic>> keyInsects = [
    {
      'name': 'Sogata del Arroz',
      'scientificName': 'Tagosodes orizicolus',
      'crops': ['Arroz'],
      'importance': 'Principal vector del virus de la hoja blanca del arroz (VHBA) en Panamá. Afecta severamente las zonas arroceras de Chiriquí y Coclé, causando pérdidas de hasta el 50% en la producción.',
      'control': '• Variedades resistentes al VHBA\n• Control biológico con parasitoides\n• Manejo del agua de riego\n• Aplicación de ARN interferente específico\n• Monitoreo con trampas amarillas',
      'icon': Icons.grass,
      'emoji': '🦗',
    },
    {
      'name': 'Broca del Café',
      'scientificName': 'Hypothenemus hampei',
      'crops': ['Café'],
      'importance': 'Plaga clave en las zonas cafetaleras de Boquete y Volcán. Investigaciones del IDIAP han demostrado que puede reducir la producción hasta en un 35% y afectar la calidad de exportación del café panameño.',
      'control': '• Control biológico con Beauveria bassiana\n• Trampas con atrayentes (etanol-metanol)\n• Cosecha sanitaria\n• Manejo de sombra\n• Monitoreo fenológico',
      'icon': Icons.coffee,
      'emoji': '🪲',
    },
    {
      'name': 'Picudo Negro del Plátano',
      'scientificName': 'Cosmopolites sordidus',
      'crops': ['Plátano', 'Banano'],
      'importance': 'Plaga crítica en las plantaciones de Barú y Bocas del Toro. Las investigaciones del CATIE en Panamá han documentado pérdidas de hasta 60% en plantaciones no manejadas.',
      'control': '• Trampas tipo sándwich\n• Control biológico con hongos entomopatógenos\n• Eliminación de pseudotallos infestados\n• Uso de cormos sanos\n• Rotación de cultivos',
      'icon': Icons.pest_control,
      'emoji': '🪲',
    },
    {
      'name': 'Mosca Blanca',
      'scientificName': 'Bemisia tabaci',
      'crops': ['Sandía', 'Melón', 'Tomate', 'Pimentón'],
      'importance': 'Vector de geminivirus en cultivos hortícolas de la península de Azuero. Estudios de la Universidad de Panamá han identificado biotipos específicos adaptados a las condiciones locales.',
      'control': '• Barreras vivas\n• Control biológico con Encarsia formosa\n• Rotación de cultivos\n• Mallas anti-insectos\n• Monitoreo con trampas amarillas',
      'icon': Icons.bug_report,
      'emoji': '🪰',
    },
    {
      'name': 'Ácaro Rojo de las Palmas',
      'scientificName': 'Raoiella indica',
      'crops': ['Palma de Coco', 'Plátano', 'Plantas ornamentales'],
      'importance': 'Plaga invasora detectada recientemente en Panamá. Investigaciones del MIDA han documentado su expansión en la zona costera, representando una amenaza para la producción de coco.',
      'control': '• Control biológico con ácaros depredadores\n• Eliminación de material infestado\n• Aplicaciones de azufre\n• Monitoreo preventivo\n• Cuarentena de material vegetal',
      'icon': Icons.coronavirus,
      'emoji': '🕷️',
    },
    {
      'name': 'Chinche Salivosa',
      'scientificName': 'Aeneolamia spp.',
      'crops': ['Pastos', 'Caña de Azúcar'],
      'importance': 'Plaga clave en la ganadería panameña. Investigaciones del IDIAP en Los Santos y Veraguas han documentado reducciones del 40% en la capacidad de carga de los pastos.',
      'control': '• Manejo de la altura de pastos\n• Control biológico con Metarhizium anisopliae\n• Rotación de potreros\n• Diversificación de especies forrajeras\n• Quema controlada en casos específicos',
      'icon': Icons.grass,
      'emoji': '🐞',
    },
    {
      'name': 'Polilla de la Naranja',
      'scientificName': 'Phyllocnistis citrella',
      'crops': ['Cítricos'],
      'importance': 'Plaga emergente en los cultivos cítricos de Chiriquí. Facilita la entrada de la bacteria del HLB (Huanglongbing), enfermedad devastadora para la citricultura panameña.',
      'control': '• Control biológico con Ageniaspis citricola\n• Manejo de brotes nuevos\n• Aplicaciones de aceites minerales\n• Monitoreo de plantas jóvenes\n• Eliminación de material infestado',
      'icon': Icons.local_florist,
      'emoji': '🦋',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cardBackground = const Color(0xFF317B22);
    final customGreen = const Color(0xFF67E0A3);
    
    return BaseScreen(
      backgroundColor: Colors.white,
      title: 'Insectos Clave en Panamá',
      child: ListView.builder(
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
