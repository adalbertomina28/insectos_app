import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/language_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  // Función para abrir WhatsApp
  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/50766929027');
    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      // Si no se puede abrir WhatsApp, mostrar un mensaje de error usando GetX
      Get.snackbar(
        'Error',
        'No se pudo abrir WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en un dispositivo móvil o pantalla pequeña
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'InsectLab',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: isMobile
            ? [
                LanguageSelector(),
                const SizedBox(width: 16),
              ]
            : [
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: Text('Iniciar Sesión', style: TextStyle(color: Colors.black87)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _launchWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('Contáctanos en WhatsApp'),
                ),
                const SizedBox(width: 24),
                LanguageSelector(),
                const SizedBox(width: 16),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(isMobile),
            _buildIdealForSection(isMobile),
            _buildHowItWorksSection(isMobile),
            _buildFeaturesSection(isMobile),
            _buildCTASection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    // Contenido del encabezado adaptado a dispositivos móviles o escritorio
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24, 
        vertical: isMobile ? 32 : 64
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: isMobile
          // Diseño para móviles (columna vertical)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texto principal
                Text(
                  'Explora el fascinante mundo de los insectos de Panamá',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Accede a una base de datos completa de insectos, identifica especies por ubicación y aprende sobre plagas clave en la región con nuestra plataforma especializada.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Imagen
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/home/landing_img.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  '¡Busca un insecto y prueba el servicio tú mismo!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botones adaptados para móvil (uno debajo del otro)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Crear cuenta gratis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    OutlinedButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          // Diseño para escritorio (fila horizontal)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda con texto
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Identifica insectos con inteligencia artificial y aprende sobre ellos',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'La solución más sencilla para identificar, aprender y compartir información sobre insectos de forma rápida y educativa.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        '¡Envía una foto de un insecto y prueba el servicio tú mismo!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Crear cuenta gratis',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          OutlinedButton(
                            onPressed: () => Get.toNamed(AppRoutes.login),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              side: BorderSide(color: AppTheme.primaryColor),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 40),
                
                // Columna derecha con imagen
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/home/landing_img.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  
  // Método para construir las tarjetas de "Para quién es"
  Widget _buildIdealForCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIdealForSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80, 
        horizontal: 24
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¿Para Quién es?',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 40),
            child: Text(
              'Nuestra plataforma está diseñada para apoyar a diversos perfiles interesados en la entomología y la agricultura sostenible en Panamá',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.black54,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(height: isMobile ? 32 : 60),
          
          // Diseño responsivo con GridView
          LayoutBuilder(
            builder: (context, constraints) {
              // Ajustamos el número de columnas según el ancho de la pantalla
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1000) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 2;
              }
              
              // Ajustamos el ancho de las tarjetas según el número de columnas
              final double cardWidth = isMobile 
                  ? constraints.maxWidth - 48 // Restamos el padding horizontal
                  : (constraints.maxWidth - 48 - ((crossAxisCount - 1) * 24)) / crossAxisCount;
              
              // Ajustamos el diseño para que las tarjetas se ajusten al contenido
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.00, // Proporción más compacta
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                children: [
                  _buildIdealForCard(
                    'Agricultores',
                    'Identifica y gestiona plagas en cultivos con información específica para Panamá.',
                    Icons.agriculture,
                    Colors.green,
                  ),
                  _buildIdealForCard(
                    'Estudiantes',
                    'Accede a recursos educativos sobre entomología y biodiversidad local.',
                    Icons.school,
                    Colors.blue,
                  ),
                  _buildIdealForCard(
                    'Aficionados',
                    'Explora y aprende sobre la diversidad de insectos panameños.',
                    Icons.nature_people,
                    Colors.orange,
                  ),
                  _buildIdealForCard(
                    'Profesionales',
                    'Mantente actualizado sobre manejo de plagas y especies beneficiosas.',
                    Icons.engineering,
                    Colors.purple,
                  ),
                  _buildIdealForCard(
                    'Investigadores',
                    'Accede a datos sobre distribución de especies en ecosistemas locales.',
                    Icons.biotech,
                    Colors.teal,
                  ),
                ].where((widget) => widget != null).toList(),
              );
            },
          ),
          
          const SizedBox(height: 40),
          
          // Botón de contacto
          ElevatedButton(
            onPressed: _launchWhatsApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Contáctanos por WhatsApp',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildIdealForItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHowItWorksSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80, 
        horizontal: 24
      ),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¿Cómo funciona?',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(height: isMobile ? 32 : 64),
          
          // Usamos un GridView que se adapta al tamaño de pantalla
          LayoutBuilder(
            builder: (context, constraints) {
              // Para pantallas pequeñas mostramos 1 columna, para medianas 2, para grandes 3
              int crossAxisCount = 1;
              if (constraints.maxWidth > 1000) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 2;
              }
              
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: crossAxisCount == 1 ? 1.5 : 1.2,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 20),
                children: [
                  _buildHowItWorksStep(
                    '1. Explora la base de datos',
                    'Navega por nuestra base de datos de insectos con información detallada y fotografías de referencia.',
                    Icons.search,
                  ),
                  _buildHowItWorksStep(
                    '2. Consulta por ubicación',
                    'Descubre qué insectos son comunes en diferentes regiones de Panamá con nuestro mapa interactivo.',
                    Icons.location_on,
                  ),
                  _buildHowItWorksStep(
                    '3. Consulta al asistente',
                    'Obtén información específica sobre especies y plagas con nuestro asistente virtual.',
                    Icons.chat_bubble_outline,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildHowItWorksStep(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  // Método para construir el ícono de flecha entre pasos
  Widget _buildArrowIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(
        Icons.arrow_forward,
        color: AppTheme.primaryColor,
        size: 24,
      ),
    );
  }

  Widget _buildIntroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '¿Qué es InsectosApp?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'InsectosApp es una plataforma educativa diseñada para ayudarte a identificar, aprender y explorar el fascinante mundo de los insectos. Ya seas un entusiasta, estudiante, investigador o simplemente curioso, nuestra aplicación te ofrece herramientas y recursos para profundizar en el conocimiento entomológico.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 48),
          
          // Estadísticas o números destacados
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('1M+', 'Especies identificadas'),
              _buildStatCard('50K+', 'Usuarios activos'),
              _buildStatCard('100+', 'Países'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80, 
        horizontal: 24
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Funcionalidades Principales',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Container(
            constraints: BoxConstraints(maxWidth: 1000),
            child: isMobile
                ? Column(
                    children: [
                      _buildFeatureCard(
                        'Base de Datos Central',
                        'Accede a información detallada de cientos de especies de insectos, con datos científicos y fotografías de referencia.',
                        Icons.storage,
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureCard(
                        'Identificación por Ubicación',
                        'Descubre qué insectos habitan en diferentes regiones de Panamá y su impacto en el ecosistema local.',
                        Icons.map,
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureCard(
                        'Asistente Virtual Inteligente',
                        'Interactúa con nuestro asistente IA para resolver dudas sobre insectos y su manejo en entornos agrícolas.',
                        Icons.smart_toy_outlined,
                      ),
                      const SizedBox(height: 24),
                      _buildFeatureCard(
                        'Guía de Plagas Clave',
                        'Aprende sobre las principales plagas agrícolas de la región y las mejores prácticas para su manejo sostenible.',
                        Icons.eco,
                      ),
                    ],
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    children: [
                      _buildFeatureCard(
                        'Base de Datos Central',
                        'Accede a información detallada de cientos de especies de insectos, con datos científicos y fotografías de referencia.',
                        Icons.storage,
                      ),
                      _buildFeatureCard(
                        'Identificación por Ubicación',
                        'Descubre qué insectos habitan en diferentes regiones de Panamá y su impacto en el ecosistema local.',
                        Icons.map,
                      ),
                      _buildFeatureCard(
                        'Asistente Virtual Inteligente',
                        'Interactúa con nuestro asistente IA para resolver dudas sobre insectos y su manejo en entornos agrícolas.',
                        Icons.smart_toy_outlined,
                      ),
                      _buildFeatureCard(
                        'Guía de Plagas Clave',
                        'Aprende sobre las principales plagas agrícolas de la región y las mejores prácticas para su manejo sostenible.',
                        Icons.eco,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280, minHeight: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80, 
        horizontal: 24
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.calPolyGreen.withOpacity(0.9),
            AppTheme.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            '¿Listo para explorar el mundo de los insectos?',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 16 : 24),
          
          Text(
            'Regístrate hoy mismo y descubre todas las funcionalidades que InsectLab tiene para ti.',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 24 : 32),
          
          // Usamos un Column para móviles y un Row para escritorio
          isMobile
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón de WhatsApp
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _launchWhatsApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Contáctanos por WhatsApp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón de registro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.register),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Crear cuenta gratis',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Contáctanos por WhatsApp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Crear cuenta gratis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    // Determinar si estamos en un dispositivo móvil o pantalla pequeña
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : 48, 
        horizontal: 24
      ),
      color: Colors.grey[900],
      child: Column(
        children: [
          Text(
            'InsectLab',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            '© ${DateTime.now().year} InsectLab. Todos los derechos reservados.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Text(text),
    );
  }
}

class HexagonPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.calPolyGreen.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double hexagonSize = 30;
    const double horizontalSpacing = hexagonSize * 1.5;
    final double verticalSpacing = hexagonSize * 1.732; // aproximación de sqrt(3)

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
