import 'dart:async';
import 'dart:html' if (dart.library.io) 'dart:io' show window;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';
import 'controllers/language_controller.dart';
import 'controllers/insect_controller.dart';
import 'controllers/auth_controller.dart';
import 'config/supabase_config.dart';

// Variable global para el manejo de Deep Links
final _appLinks = AppLinks();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Imprimir la configuración actual de Supabase (para depuración)
  SupabaseConfig.printConfig();
  
  // Inicializar Supabase con configuración de Deep Links
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
    authFlowType: AuthFlowType.pkce,
    debug: true,
  );
  
  // Registrar controladores
  Get.put(LanguageController());
  Get.put(InsectController());
  final authController = Get.put(AuthController());
  
  // Configurar el manejo de autenticación según la plataforma
  if (kIsWeb) {
    // En web, Supabase maneja automáticamente el flujo PKCE
    // Verificar si hay una sesión activa
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {

      authController.setSession(session);
    } else {

    }
    
    // Escuchar cambios en la autenticación
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {

      if (data.session != null) {

        authController.setSession(data.session!);
      }
    });
  } else {
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

  
  // Verificar si hay un código de autenticación en la URL
  if (uri.queryParameters.containsKey('code')) {
    final code = uri.queryParameters['code'];

    
    // Procesar el código de autenticación
    authController.processAuthCode(code!);
  } else {

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
    
    return GetMaterialApp(
      title: 'InsectLab',
      theme: AppTheme.theme,
      translations: AppTranslations(),
      locale: const Locale('es'),
      fallbackLocale: const Locale('en'),
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.landing,
      debugShowCheckedModeBanner: false,
      // Callback cuando la app esté lista
      onInit: () {
        // Verificar si hay una sesión activa y redirigir si es necesario
        if (authController.isAuthenticated.value) {
          // Si el usuario ya está autenticado, llevarlo directamente al home
          // Usar un pequeño retraso para asegurar que la navegación funcione correctamente
          Future.delayed(Duration(milliseconds: 100), () {
            Get.offAllNamed(AppRoutes.home);
          });
        }
        // Si no está autenticado, se quedará en la ruta inicial (landing)
      },
    );
  }
}
