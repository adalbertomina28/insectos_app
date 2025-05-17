import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/language_selector.dart';
import '../../theme/app_theme.dart';

class KeyInsectsScreen extends StatelessWidget {
  KeyInsectsScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> keyInsects = [
    {
      'name': 'Sogata del Arroz',
      'scientificName': 'Tagosodes orizicolus',
      'crops': ['Arroz'],
      'importance':
          'Principal vector del virus de la hoja blanca del arroz (VHBA) en Panamá. Afecta severamente las zonas arroceras de Chiriquí y Coclé, causando pérdidas de hasta el 50% en la producción.',
      'control':
          '• Variedades resistentes al VHBA\n• Control biológico con parasitoides\n• Manejo del agua de riego\n• Aplicación de ARN interferente específico\n• Monitoreo con trampas amarillas',
      'icon': Icons.grass,
      'emoji': '🦗',
    },
    {
      'name': 'Broca del Café',
      'scientificName': 'Hypothenemus hampei',
      'crops': ['Café'],
      'importance':
          'Plaga clave en las zonas cafetaleras de Boquete y Volcán. Investigaciones del IDIAP han demostrado que puede reducir la producción hasta en un 35% y afectar la calidad de exportación del café panameño.',
      'control':
          '• Control biológico con Beauveria bassiana\n• Trampas con atrayentes (etanol-metanol)\n• Cosecha sanitaria\n• Manejo de sombra\n• Monitoreo fenológico',
      'icon': Icons.coffee,
      'emoji': '🪲',
    },
    {
      'name': 'Picudo Negro del Plátano',
      'scientificName': 'Cosmopolites sordidus',
      'crops': ['Plátano', 'Banano'],
      'importance':
          'Plaga crítica en las plantaciones de Barú y Bocas del Toro. Las investigaciones del CATIE en Panamá han documentado pérdidas de hasta 60% en plantaciones no manejadas.',
      'control':
          '• Trampas tipo sándwich\n• Control biológico con hongos entomopatógenos\n• Eliminación de pseudotallos infestados\n• Uso de cormos sanos\n• Rotación de cultivos',
      'icon': Icons.pest_control,
      'emoji': '🪲',
    },
    {
      'name': 'Mosca Blanca',
      'scientificName': 'Bemisia tabaci',
      'crops': ['Sandía', 'Melón', 'Tomate', 'Pimentón'],
      'importance':
          'Vector de geminivirus en cultivos hortícolas de la península de Azuero. Estudios de la Universidad de Panamá han identificado biotipos específicos adaptados a las condiciones locales.',
      'control':
          '• Barreras vivas\n• Control biológico con Encarsia formosa\n• Rotación de cultivos\n• Mallas anti-insectos\n• Monitoreo con trampas amarillas',
      'icon': Icons.bug_report,
      'emoji': '🪰',
    },
    {
      'name': 'Ácaro Rojo de las Palmas',
      'scientificName': 'Raoiella indica',
      'crops': ['Palma de Coco', 'Plátano', 'Plantas ornamentales'],
      'importance':
          'Plaga invasora detectada recientemente en Panamá. Investigaciones del MIDA han documentado su expansión en la zona costera, representando una amenaza para la producción de coco.',
      'control':
          '• Control biológico con ácaros depredadores\n• Eliminación de material infestado\n• Aplicaciones de azufre\n• Monitoreo preventivo\n• Cuarentena de material vegetal',
      'icon': Icons.coronavirus,
      'emoji': '🕷️',
    },
    {
      'name': 'Chinche Salivosa',
      'scientificName': 'Aeneolamia spp.',
      'crops': ['Pastos', 'Caña de Azúcar'],
      'importance':
          'Plaga clave en la ganadería panameña. Investigaciones del IDIAP en Los Santos y Veraguas han documentado reducciones del 40% en la capacidad de carga de los pastos.',
      'control':
          '• Manejo de la altura de pastos\n• Control biológico con Metarhizium anisopliae\n• Rotación de potreros\n• Diversificación de especies forrajeras\n• Quema controlada en casos específicos',
      'icon': Icons.grass,
      'emoji': '🐞',
    },
    {
      'name': 'Polilla de la Naranja',
      'scientificName': 'Phyllocnistis citrella',
      'crops': ['Cítricos'],
      'importance':
          'Plaga emergente en los cultivos cítricos de Chiriquí. Facilita la entrada de la bacteria del HLB (Huanglongbing), enfermedad devastadora para la citricultura panameña.',
      'control':
          '• Control biológico con Ageniaspis citricola\n• Manejo de brotes nuevos\n• Aplicaciones de aceites minerales\n• Monitoreo de plantas jóvenes\n• Eliminación de material infestado',
      'icon': Icons.local_florist,
      'emoji': '🦋',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cardBackground = AppTheme.calPolyGreen;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: BaseScreen.buildDrawer(context),
      body: Column(
        children: [
          // Header con diseño moderno
          Container(
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
                // Imagen de insectos clave
                Image.asset(
                  'images/vectors/key_insect.png',
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {

                    return Container(
                      height: 180,
                      width: 180,
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.bug_report,
                        size: 64,
                        color: AppTheme.calPolyGreen.withOpacity(0.5),
                      ),
                    );
                  },
                ),
                // Título centrado
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Insectos Clave en Panamá',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: keyInsects.length,
                itemBuilder: (context, index) {
                  final insect = keyInsects[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
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
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.calPolyGreen.withOpacity(0.1),
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
                            child: Text(
                              insect['emoji'] as String,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        title: Text(
                          insect['name'] as String,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            letterSpacing: -0.5,
                          ),
                        ),
                        subtitle: Text(
                          insect['scientificName'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(19),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Cultivos afectados
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.agriculture,
                                            size: 18,
                                            color: AppTheme.calPolyGreen,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Cultivos Afectados',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        (insect['crops'] as List<String>).join(', '),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Importancia
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber,
                                            size: 18,
                                            color: Colors.amber[700],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Importancia',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        insect['importance'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Métodos de control
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.security,
                                            size: 18,
                                            color: AppTheme.calPolyGreen,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Métodos de Control',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        insect['control'] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon,
      Color textColor, Color backgroundColor) {
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
