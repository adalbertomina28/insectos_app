import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Acerca de',
          style: TextStyle(
            color: AppTheme.calPolyGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.calPolyGreen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuestra Misión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.calPolyGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Insect Lab nace con el propósito de hacer accesible el fascinante mundo de la entomología a estudiantes, profesionales y entusiastas. Nuestra misión es proporcionar una plataforma educativa completa y precisa sobre los insectos.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.officeGreen.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Equipo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.calPolyGreen,
                ),
              ),
              const SizedBox(height: 16),
              _buildTeamMember(
                'Ing. Adalberto Mina',
                'Ingeniero de Software',
                'Especialista en desarrollo de aplicaciones y arquitectura tecnológica.',
              ),
              _buildTeamMember(
                'Dra. Maria Paula Mejia',
                'Entomóloga Principal',
                'Maestría en Entomología Aplicada a la Agricultura.',
              ),
              const SizedBox(height: 32),
              const Text(
                'Contacto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.calPolyGreen,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.email,
                'Email',
                'bugsappproject@gmail.com',
              ),
              _buildContactItem(
                Icons.web,
                'Sitio Web',
                'www.insectlab.app',
              ),
              _buildContactItem(
                Icons.location_on,
                'Ubicación',
                'Ciudad de Panamá, Panamá',
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.emerald.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Colabora con Nosotros',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.calPolyGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Si eres entomólogo, biólogo o entusiasta de los insectos y te gustaría contribuir con contenido para la aplicación, ¡nos encantaría escucharte!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.officeGreen.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF317B22),
            const Color(0xFF67E0A3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.emerald,
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.calPolyGreen,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.officeGreen.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
