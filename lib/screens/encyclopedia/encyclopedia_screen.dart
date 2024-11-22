import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/encyclopedia_controller.dart';
import '../../models/insect.dart';
import '../../theme/app_theme.dart';
import 'insect_detail_screen.dart';

class EncyclopediaScreen extends StatelessWidget {
  EncyclopediaScreen({Key? key}) : super(key: key);

  final EncyclopediaController controller = Get.put(EncyclopediaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enciclopedia de Insectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.searchInsects,
              decoration: InputDecoration(
                hintText: 'Buscar insectos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.insects.length,
                itemBuilder: (context, index) {
                  final insect = controller.insects[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () => Get.to(() => InsectDetailScreen(insect: insect)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.calPolyGreen.withOpacity(0.1),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  insect.emoji,
                                  style: const TextStyle(fontSize: 50),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    insect.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    insect.scientificName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Categoría',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Obx(
                            () => FilterChip(
                              label: Text(category),
                              selected:
                                  controller.selectedCategory.value == category,
                              onSelected: (selected) {
                                controller.setCategory(
                                    selected ? category : '');
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hábitat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.habitats
                      .map(
                        (habitat) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Obx(
                            () => FilterChip(
                              label: Text(habitat),
                              selected: controller.selectedHabitat.value == habitat,
                              onSelected: (selected) {
                                controller.setHabitat(
                                    selected ? habitat : '');
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Actividad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.activities
                      .map(
                        (activity) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Obx(
                            () => FilterChip(
                              label: Text(activity),
                              selected:
                                  controller.selectedActivity.value == activity,
                              onSelected: (selected) {
                                controller.setActivity(
                                    selected ? activity : '');
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
