import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  final List<Map<String, dynamic>> resources = [
    {
      'title': 'Guías de Identificación',
      'items': [
        {
          'name': 'Manual de Identificación de Plagas',
          'description': 'Guía completa para identificar plagas agrícolas comunes',
          'type': 'PDF',
          'icon': Icons.picture_as_pdf,
        },
        {
          'name': 'Atlas de Insectos Benéficos',
          'description': 'Catálogo visual de insectos beneficiosos para la agricultura',
          'type': 'Galería',
          'icon': Icons.photo_library,
        },
      ]
    },
    {
      'title': 'Material Educativo',
      'items': [
        {
          'name': 'Introducción al Control Biológico',
          'description': 'Curso básico sobre control biológico de plagas',
          'type': 'Curso',
          'icon': Icons.school,
        },
        {
          'name': 'Biotecnología en Agricultura',
          'description': 'Serie de videos sobre aplicaciones biotecnológicas',
          'type': 'Video',
          'icon': Icons.play_circle,
        },
      ]
    },
    {
      'title': 'Enlaces Útiles',
      'items': [
        {
          'name': 'FAO - Control de Plagas',
          'description': 'Recursos oficiales de la FAO sobre manejo de plagas',
          'type': 'Enlace',
          'icon': Icons.link,
        },
        {
          'name': 'Base de Datos de Insectos',
          'description': 'Repositorio internacional de información sobre insectos',
          'type': 'Base de datos',
          'icon': Icons.storage,
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos'),
      ),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final category = resources[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  category['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...List.generate(
                (category['items'] as List).length,
                (itemIndex) {
                  final item = category['items'][itemIndex];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      leading: Icon(item['icon'] as IconData),
                      title: Text(item['name']),
                      subtitle: Text(item['description']),
                      trailing: Chip(
                        label: Text(item['type']),
                        backgroundColor: Colors.green.shade100,
                      ),
                      onTap: () {
                        // Aquí se implementará la lógica para abrir cada recurso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Abriendo: ${item['name']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
