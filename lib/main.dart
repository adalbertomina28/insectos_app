import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';
import 'controllers/language_controller.dart';
import 'controllers/insect_controller.dart';
import 'config/api_config.dart';

void main() {
  // Imprimir información de depuración al inicio de la aplicación
  print('======================================');
  print('==== INICIANDO APLICACIÓN ====');
  print('BACKEND_API_BASE_URL = $BACKEND_API_BASE_URL');
  print('FORCED_API_URL = $FORCED_API_URL');
  print('======================================');
  
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
    // Imprimir información de depuración al construir la aplicación
    print('======================================');
    print('==== CONSTRUYENDO APP ====');
    print('BACKEND_API_BASE_URL = $BACKEND_API_BASE_URL');
    print('FORCED_API_URL = $FORCED_API_URL');
    print('======================================');
    
    return GetMaterialApp(
      title: 'InsectLab',
      theme: AppTheme.theme,
      translations: AppTranslations(),
      locale: const Locale('es'),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
      debugShowCheckedModeBanner: false,
      // Agregar callback para imprimir información cuando la app esté lista
      onInit: () {
        print('======================================');
        print('==== APP INICIALIZADA ====');
        print('BACKEND_API_BASE_URL = $BACKEND_API_BASE_URL');
        print('FORCED_API_URL = $FORCED_API_URL');
        print('======================================');
      },
    );
  }
}
