import 'package:get/get.dart';
import '../services/inaturalist_service.dart';
import '../models/insect_model.dart';

class InsectController extends GetxController {
  final _service = InsectService();

  // Estado observable para la búsqueda
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Insect> searchResults = <Insect>[].obs;
  final RxInt totalResults = 0.obs;
  final RxInt currentPage = 1.obs;

  // Estado para el insecto seleccionado
  final Rx<Insect?> selectedInsect = Rx<Insect?>(null);

  // Estado para insectos cercanos
  final RxList<Insect> nearbyInsects = <Insect>[].obs;

  // Idioma actual
  final RxString currentLocale = 'es'.obs;

  Future<void> searchInsects(String query, {int page = 1}) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.searchInsects(
        query: query,
        page: page,
        locale: currentLocale.value,
      );

      if (page == 1) {
        searchResults.clear();
      }

      final List<Insect> fetchedResults =
          (result['results'] as List?)
              ?.map((item) => Insect.fromJson(item))
              ?.toList() ??
          [];

      searchResults.addAll(fetchedResults);
      totalResults.value = result['total_results'] ?? 0;
      currentPage.value = page;
    } catch (e) {
      error.value = 'error_loading'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getInsectDetails(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final insectData = await _service.getInsectDetails(
        id,
        locale: currentLocale.value,
      );

      selectedInsect.value = Insect.fromJson(insectData);
    } catch (e) {
      error.value = 'error_loading_details'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNearbyInsects({
    required double latitude,
    required double longitude,
    int radius = 50,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await _service.getNearbyInsects(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        locale: currentLocale.value,
      );

      final List<Insect> fetchedResults =
          (result['results'] as List?)
              ?.map((item) => Insect.fromJson(item))
              ?.toList() ??
          [];

      nearbyInsects.value = fetchedResults;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeLocale(String locale) {
    currentLocale.value = locale;
  }
}
