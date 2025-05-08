import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';
import 'controllers/language_controller.dart';
import 'controllers/insect_controller.dart';

void main() {
  // Registrar controladores
  Get.put(LanguageController());
  Get.put(InsectController());
  
  // Ejecutar la aplicación
  runApp(const InsectosApp());
}

class InsectosApp extends StatelessWidget {
  const InsectosApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      title: 'InsectLab',
      theme: AppTheme.theme,
      translations: AppTranslations(),
      locale: const Locale('es'),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
      debugShowCheckedModeBanner: false,
      // Callback cuando la app esté lista
      onInit: () {
        // La aplicación ha sido inicializada
      },
    );
  }
}
