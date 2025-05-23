import 'package:get/get.dart';
import 'package:insectos_app/models/observation_model.dart';
import 'package:insectos_app/routes/app_routes.dart';
import 'package:insectos_app/services/observation_service.dart';

class ObservationController extends GetxController {
  final ObservationService _observationService = ObservationService();
  
  // Variables observables
  final RxList<Observation> observations = <Observation>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Variables para la creación de observaciones
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxInt conditionId = 1.obs;
  final RxInt stateId = 1.obs;
  final RxInt stageId = 1.obs;
  final RxInt sexId = 1.obs;
  final RxList<String> photoUrls = <String>[].obs;
  final RxString scientificName = ''.obs;
  final RxString commonName = ''.obs;
  final RxString description = ''.obs;
  final RxInt inaturalistId = 0.obs;
  
  // Variables para la búsqueda de insectos
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool hasSelectedInsect = false.obs;
  
  // Catálogos
  final RxList<Map<String, dynamic>> conditions = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> states = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> stages = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> sexes = <Map<String, dynamic>>[].obs;
  final RxBool loadingCatalogs = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('ObservationController.onInit() llamado');
    fetchUserObservations();
    loadCatalogs();
  }
  
  // Cargar todos los catálogos
  Future<void> loadCatalogs() async {
    try {
      loadingCatalogs.value = true;
      
      // Cargar todos los catálogos en paralelo
      await Future.wait([
        loadConditions(),
        loadStates(),
        loadStages(),
        loadSexes(),
      ]);
      
      loadingCatalogs.value = false;
    } catch (e) {
      loadingCatalogs.value = false;
      print('Error cargando catálogos: $e');
    }
  }
  
  // Cargar catálogo de condiciones
  Future<void> loadConditions() async {
    try {
      final result = await _observationService.getConditions();
      conditions.value = result;
    } catch (e) {
      print('Error cargando condiciones: $e');
    }
  }
  
  // Cargar catálogo de estados
  Future<void> loadStates() async {
    try {
      final result = await _observationService.getStates();
      states.value = result;
    } catch (e) {
      print('Error cargando estados: $e');
    }
  }
  
  // Cargar catálogo de etapas
  Future<void> loadStages() async {
    try {
      final result = await _observationService.getStages();
      stages.value = result;
    } catch (e) {
      print('Error cargando etapas: $e');
    }
  }
  
  // Cargar catálogo de sexos
  Future<void> loadSexes() async {
    try {
      final result = await _observationService.getSexes();
      sexes.value = result;
    } catch (e) {
      print('Error cargando sexos: $e');
    }
  }
  
  // Cargar las observaciones del usuario
  Future<void> fetchUserObservations() async {
    try {
      print('Iniciando fetchUserObservations');
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final userObservations = await _observationService.getUserObservations();
      print('Observaciones obtenidas: ${userObservations.length}');
      observations.value = userObservations;
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error al cargar las observaciones: $e';
      print('Error en fetchUserObservations: $e');
    }
  }
  
  // Obtener una observación específica
  Future<Observation?> getObservation(String observationId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final observation = await _observationService.getObservation(observationId);
      
      isLoading.value = false;
      return observation;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error al obtener la observación: $e';
      print('Error en getObservation: $e');
      return null;
    }
  }
  
  // Eliminar una observación
  Future<bool> deleteObservation(String observationId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final success = await _observationService.deleteObservation(observationId);
      
      if (success) {
        // Eliminar la observación de la lista local
        observations.removeWhere((obs) => obs.id == observationId);
      }
      
      isLoading.value = false;
      return success;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error al eliminar la observación: $e';
      print('Error en deleteObservation: $e');
      return false;
    }
  }
  
  // Refrescar las observaciones
  Future<void> refreshObservations() async {
    await fetchUserObservations();
  }
  
  // Buscar insectos por nombre
  Future<void> searchInsects(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    
    try {
      isSearching.value = true;
      final results = await _observationService.searchInsectsByName(query);
      searchResults.value = results;
      isSearching.value = false;
    } catch (e) {
      isSearching.value = false;
      print('Error en searchInsects: $e');
    }
  }
  
  // Seleccionar un insecto de los resultados de búsqueda
  void selectInsect(Map<String, dynamic> insect) {
    scientificName.value = insect['scientific_name'] ?? '';
    commonName.value = insect['common_name'] ?? '';
    inaturalistId.value = insect['inaturalist_id'] ?? 0;
    hasSelectedInsect.value = true;
    searchResults.clear();
  }
  
  // Crear una nueva observación
  Future<bool> createObservation({
    required String commonName,
    required DateTime observationDate,
    required double latitude,
    required double longitude,
    required int conditionId,
    required int stateId,
    required int stageId,
    required int sexId,
    String? description,
    required List<String> photoUrls,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      if (!hasSelectedInsect.value) {
        hasError.value = true;
        errorMessage.value = 'Debes seleccionar un insecto de la lista de resultados';
        isLoading.value = false;
        return false;
      }
      
      final observation = await _observationService.createObservation(
        scientificName: scientificName.value,
        commonName: commonName,
        inaturalistId: inaturalistId.value,
        observationDate: observationDate,
        latitude: latitude,
        longitude: longitude,
        conditionId: conditionId,
        stateId: stateId,
        stageId: stageId,
        sexId: sexId,
        description: description,
        photoUrls: photoUrls,
      );
      
      isLoading.value = false;
      
      if (observation != null) {
        // Añadir la nueva observación a la lista local
        observations.add(observation);
        
        // Navegar a la pantalla de éxito
        Get.offAllNamed(AppRoutes.observationSuccess);
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = 'Error al crear la observación';
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Error al crear la observación: $e';
      print('Error en createObservation: $e');
      return false;
    }
  }
  
  // Resetear los valores para una nueva observación
  void resetObservationForm() {
    selectedDate.value = DateTime.now();
    latitude.value = 0.0;
    longitude.value = 0.0;
    conditionId.value = 1;
    stateId.value = 1;
    stageId.value = 1;
    sexId.value = 1;
    photoUrls.clear();
    scientificName.value = '';
    commonName.value = '';
    description.value = '';
  }
}
