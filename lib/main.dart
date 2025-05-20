import 'dart:async';
import 'dart:html' if (dart.library.io) 'dart:io' show window;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';
import 'controllers/language_controller.dart';
import 'controllers/insect_controller.dart';
import 'controllers/auth_controller.dart';

// Variable global para el manejo de Deep Links
final _appLinks = AppLinks();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Registrar controladores
  Get.put(LanguageController());
  Get.put(InsectController());
  final authController = Get.put(AuthController());

  // Configurar el manejo de autenticación según la plataforma
  if (!kIsWeb) {
    // En plataformas móviles, configurar el manejo de Deep Links
    _setupDeepLinkHandling(authController);
  }

  // Ejecutar la aplicación
  runApp(const InsectosApp());
}

// Configurar el manejo de Deep Links
void _setupDeepLinkHandling(AuthController authController) {
  // Manejar Deep Links cuando la aplicación está en primer plano
  _appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      _handleDeepLink(uri, authController);
    }
  });

  // Verificar si la aplicación se abrió desde un Deep Link
  _appLinks.getInitialAppLink().then((Uri? uri) {
    if (uri != null) {
      _handleDeepLink(uri, authController);
    }
  });
}

// Manejar el Deep Link recibido
void _handleDeepLink(Uri uri, AuthController authController) {
  // Mostrar un snackbar para informar al usuario que se está procesando el deep link
  Get.snackbar(
    'Procesando enlace',
    'Procesando la redirección de autenticación...',
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 2),
  );

  // Verificar si hay un código de autenticación en la URL
  if (uri.queryParameters.containsKey('code')) {
    final code = uri.queryParameters['code'];

    // Mostrar información sobre el código recibido
    Get.snackbar(
      'Código recibido',
      'Procesando autenticación...',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );

    // Procesar el código de autenticación a través del backend
    authController.processAuthCode(code!);
  } else {
    // Si no hay código, informar al usuario
    Get.snackbar(
      'Error',
      'No se encontró código de autenticación en la URL',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

class InsectosApp extends StatelessWidget {
  const InsectosApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el controlador de autenticación
    final authController = Get.find<AuthController>();

    // Configurar Get para permitir la navegación sin contexto
    Get.config(enableLog: true);
    
    // Verificar si hay un código de autenticación en la URL (para web)
    if (kIsWeb) {
      final uri = Uri.parse(Uri.base.toString());
      if (uri.queryParameters.containsKey('code')) {
        final code = uri.queryParameters['code'];
        if (code != null && code.isNotEmpty) {
          // Procesar el código de autenticación
          Future.delayed(Duration(milliseconds: 500), () {
            authController.processAuthCode(code);
          });
        }
      }
    }

    return GetMaterialApp(
      title: 'InsectLab',
      theme: AppTheme.theme,
      translations: AppTranslations(),
      locale: const Locale('es'),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.login,
      debugShowCheckedModeBanner: false,
      // Callback cuando la app esté lista
      onInit: () {
        // Verificar si hay una sesión activa y redirigir si es necesario
        if (authController.isAuthenticated.value) {
          // Usar un pequeño retraso para asegurar que la navegación funcione correctamente
          Future.delayed(Duration(milliseconds: 100), () {
            Get.offAllNamed(AppRoutes.home);
          });
        }
      },
    );
  }
}
