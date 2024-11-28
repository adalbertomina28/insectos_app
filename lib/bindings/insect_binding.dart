import 'package:get/get.dart';
import '../controllers/insect_controller.dart';
import '../services/inaturalist_service.dart';

class InsectBinding extends Bindings {
  @override
  void dependencies() {
    // Registrar el servicio
    Get.lazyPut<InsectService>(() => InsectService());

    // Registrar el controlador
    Get.lazyPut<InsectController>(() => InsectController());
  }
}
