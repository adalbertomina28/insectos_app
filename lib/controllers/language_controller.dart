import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'insect_controller.dart';

/// Controlador para gestionar el idioma de la aplicación.
/// Para el MVP, se ha modificado para que la aplicación se mantenga siempre en español.
class LanguageController extends GetxController {
  static LanguageController get to => Get.find<LanguageController>();
  
  // Siempre inicializado en español
  final RxString currentLanguage = 'es'.obs;

  @override
  void onInit() {
    super.onInit();
    // Asegurarse de que la aplicación siempre inicie en español
    Get.updateLocale(const Locale('es'));
  }

  void changeLanguage(String langCode) {
    // Para el MVP, forzamos el idioma español independientemente del parámetro recibido
    langCode = 'es';
    
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
