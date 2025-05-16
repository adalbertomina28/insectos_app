import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';

/// Widget que normalmente permitiría seleccionar el idioma de la aplicación.
/// Para el MVP, se ha modificado para que no muestre nada y la aplicación
/// se mantenga siempre en español.
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Asegurarse de que el idioma esté configurado en español
    // al inicializar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (LanguageController.to.currentLanguage.value != 'es') {
        LanguageController.to.changeLanguage('es');
      }
    });
    
    // No mostrar ningún widget visible
    return const SizedBox.shrink();
  }
}
