import 'package:get/get.dart';
import '../models/nanotech_info.dart';

class NanoTechController extends GetxController {
  final RxList<NanoTechInfo> nanoTechInfoList = <NanoTechInfo>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNanoTechInfo();
  }

  Future<void> loadNanoTechInfo() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // TODO: Implement API call to fetch nanotech information
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      nanoTechInfoList.value = [
        const NanoTechInfo(
          title: 'Biomimetic Nanostructures',
          description: 'Study of insect wing nanostructures for advanced materials',
          applications: [
            'Self-cleaning surfaces',
            'Anti-reflective coatings',
            'Water-repellent materials'
          ],
          researchFindings: [
            'Hierarchical surface structures',
            'Unique optical properties',
            'Mechanical durability'
          ],
          imageUrls: [
            'assets/images/nanotech/biomimetic_1.jpg',
            'assets/images/nanotech/biomimetic_2.jpg'
          ],
        ),
        // Add more mock data as needed
      ];
    } catch (e) {
      error.value = 'Error loading nanotechnology information: \${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNanoTechInfo() async {
    await loadNanoTechInfo();
  }

  NanoTechInfo? getNanoTechInfoByTitle(String title) {
    try {
      return nanoTechInfoList.firstWhere((info) => info.title == title);
    } catch (e) {
      return null;
    }
  }

  void filterNanoTechInfo(String query) {
    if (query.isEmpty) {
      loadNanoTechInfo();
      return;
    }

    final List<NanoTechInfo> filteredList = nanoTechInfoList
        .where((info) =>
            info.title.toLowerCase().contains(query.toLowerCase()) ||
            info.description.toLowerCase().contains(query.toLowerCase()) ||
            info.applications.any((app) =>
                app.toLowerCase().contains(query.toLowerCase())) ||
            info.researchFindings.any((finding) =>
                finding.toLowerCase().contains(query.toLowerCase())))
        .toList();

    nanoTechInfoList.value = filteredList;
  }
}
