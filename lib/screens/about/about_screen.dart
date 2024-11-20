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
                'Dra. María González',
                'Entomóloga Principal',
                'Especialista en taxonomía de insectos con más de 15 años de experiencia.',
              ),
              _buildTeamMember(
                'Dr. Juan Pérez',
                'Director de Contenido',
                'PhD en Biología con enfoque en comportamiento de insectos.',
              ),
              _buildTeamMember(
                'Ing. Ana Martínez',
                'Desarrolladora Principal',
                'Especialista en desarrollo de aplicaciones educativas.',
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
                'info@insectos.app',
              ),
              _buildContactItem(
                Icons.web,
                'Sitio Web',
                'www.insectos.app',
              ),
              _buildContactItem(
                Icons.location_on,
                'Ubicación',
                'Ciudad de México, México',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.emerald.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.officeGreen.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.officeGreen.withOpacity(0.7),
            ),
          ),
        ],
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
