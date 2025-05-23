import 'package:get/get.dart';
import 'package:insectos_app/models/observation_model.dart';
import 'package:insectos_app/services/observation_service.dart';

class ObservationController extends GetxController {
  final ObservationService _observationService = ObservationService();
  
  // Variables observables
  final RxList<Observation> observations = <Observation>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchUserObservations();
  }
  
  // Cargar las observaciones del usuario
  Future<void> fetchUserObservations() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final userObservations = await _observationService.getUserObservations();
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
}
