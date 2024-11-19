import 'package:flutter/material.dart';

class KeyInsectsScreen extends StatelessWidget {
  KeyInsectsScreen({super.key});

  final List<Map<String, dynamic>> keyInsects = [
    {
      'name': 'Gusano Cogollero',
      'scientificName': 'Spodoptera frugiperda',
      'crops': ['Maíz', 'Sorgo', 'Algodón'],
      'importance': 'Plaga principal en cultivos de maíz en América Latina',
      'control': '• Control biológico con parasitoides\n• Manejo cultural\n• ARN interferente específico',
      'icon': Icons.pest_control,
    },
    {
      'name': 'Broca del Café',
      'scientificName': 'Hypothenemus hampei',
      'crops': ['Café'],
      'importance': 'Principal plaga del café a nivel mundial',
      'control': '• Control biológico con hongos\n• Trampas con feromonas\n• Manejo integrado',
      'icon': Icons.coffee,
    },
    {
      'name': 'Polilla del Tomate',
      'scientificName': 'Tuta absoluta',
      'crops': ['Tomate', 'Papa', 'Berenjena'],
      'importance': 'Causa daños severos en cultivos de solanáceas',
      'control': '• Control biológico\n• Monitoreo con feromonas\n• Manejo cultural',
      'icon': Icons.bug_report,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insectos Clave en Agricultura'),
      ),
      body: ListView.builder(
        itemCount: keyInsects.length,
        itemBuilder: (context, index) {
          final insect = keyInsects[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              leading: Icon(insect['icon'] as IconData),
              title: Text(insect['name']),
              subtitle: Text(insect['scientificName']),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection('Cultivos Afectados:', 
                        (insect['crops'] as List<String>).join(', ')),
                      const SizedBox(height: 8),
                      _buildInfoSection('Importancia:', insect['importance']),
                      const SizedBox(height: 8),
                      _buildInfoSection('Métodos de Control:', insect['control']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
