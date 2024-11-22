import 'package:get/get.dart';
import '../models/insect.dart';
import '../data/insects_data.dart';

class EncyclopediaController extends GetxController {
  final RxList<Insect> insects = <Insect>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedHabitat = ''.obs;
  final RxString selectedActivity = ''.obs;

  List<String> get categories {
    final Set<String> uniqueCategories = {};
    for (var insect in allInsects) {
      uniqueCategories.addAll(insect.categories);
    }
    return uniqueCategories.toList()..sort();
  }

  List<String> get habitats {
    final Set<String> uniqueHabitats = {};
    for (var insect in allInsects) {
      uniqueHabitats.addAll(insect.habitat);
    }
    return uniqueHabitats.toList()..sort();
  }

  List<String> get activities {
    final Set<String> uniqueActivities = {};
    for (var insect in allInsects) {
      uniqueActivities.addAll(insect.activity);
    }
    return uniqueActivities.toList()..sort();
  }

  @override
  void onInit() {
    super.onInit();
    loadInsects();
  }

  void loadInsects() {
    insects.value = allInsects;
  }

  void searchInsects(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setHabitat(String habitat) {
    selectedHabitat.value = habitat;
    applyFilters();
  }

  void setActivity(String activity) {
    selectedActivity.value = activity;
    applyFilters();
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedHabitat.value = '';
    selectedActivity.value = '';
    searchQuery.value = '';
    loadInsects();
  }

  void applyFilters() {
    var filtered = allInsects;

    // Aplicar búsqueda por texto
    if (searchQuery.isNotEmpty) {
      final lowercaseQuery = searchQuery.toLowerCase();
      filtered = filtered.where((insect) {
        return insect.name.toLowerCase().contains(lowercaseQuery) ||
            insect.scientificName.toLowerCase().contains(lowercaseQuery) ||
            insect.description.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }

    // Aplicar filtro por categoría
    if (selectedCategory.isNotEmpty) {
      filtered = filtered.where((insect) => 
        insect.categories.contains(selectedCategory.value)
      ).toList();
    }

    // Aplicar filtro por hábitat
    if (selectedHabitat.isNotEmpty) {
      filtered = filtered.where((insect) => 
        insect.habitat.contains(selectedHabitat.value)
      ).toList();
    }

    // Aplicar filtro por actividad
    if (selectedActivity.isNotEmpty) {
      filtered = filtered.where((insect) => 
        insect.activity.contains(selectedActivity.value)
      ).toList();
    }

    insects.value = filtered;
  }
}
