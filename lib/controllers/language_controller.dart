import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'insect_controller.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find<LanguageController>();
  
  final RxString currentLanguage = 'es'.obs;

  void changeLanguage(String langCode) {
    currentLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));
    
    // También actualizamos el locale en el controlador de insectos
    if (Get.isRegistered<InsectController>()) {
      final insectController = Get.find<InsectController>();
      insectController.currentLocale.value = langCode;
      
      // Si estamos en la pantalla de detalles, recargamos los detalles
      if (Get.currentRoute.contains('detail')) {
        insectController.getInsectDetails(insectController.selectedInsect.value?.id ?? 0);
      }
    }
  }
}
