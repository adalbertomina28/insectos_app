import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/insect_binding.dart';
import '../bindings/auth_binding.dart';
import '../controllers/auth_controller.dart';
import '../screens/encyclopedia/encyclopedia_screen.dart';
import '../screens/rna/rna_screen.dart';
import '../screens/insect_search/insect_search_screen.dart';
import '../screens/insect_search/insect_detail_screen.dart';
import '../screens/key_insects/key_insects_screen.dart';
import '../screens/resources/resources_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/identification/identification_screen.dart';
import '../screens/map/insect_map_screen.dart';
import '../screens/chatbot/chatbot_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/settings/account_settings_screen.dart';
import '../screens/settings/change_password_screen.dart';
import '../screens/observations/my_observations_screen.dart';

class AppRoutes {
  // Rutas de autenticación
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Rutas de la aplicación
  static const String home = '/';
  static const String encyclopedia = '/encyclopedia';
  static const String rna = '/rna';
  static const String insectSearch = '/insect-search';
  static const String keyInsects = '/key-insects';
  static const String resources = '/resources';
  static const String about = '/about';
  static const String identification = '/identification';
  static const String insectMap = '/insect-map';
  static const String insectDetails = '/insect-details';
  static const String chatbot = '/chatbot';
  static const String accountSettings = '/account-settings';
  static const String changePassword = '/change-password';
  static const String myObservations = '/my-observations';

  static List<GetPage> pages = [
    // Rutas de autenticación
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    
    // Rutas de la aplicación
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: encyclopedia,
      page: () => EncyclopediaScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: rna,
      page: () => const RNAScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: insectSearch,
      page: () => InsectSearchScreen(),
      binding: InsectBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: keyInsects,
      page: () => KeyInsectsScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: resources,
      page: () => ResourcesScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: about,
      page: () => AboutScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: identification,
      page: () => IdentificationScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: insectMap,
      page: () => const InsectMapScreen(),
      binding: InsectBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: insectDetails,
      page: () => InsectDetailScreen(insect: Get.arguments),
      binding: InsectBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: chatbot,
      page: () => const ChatbotScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: accountSettings,
      page: () => const AccountSettingsScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordScreen(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: myObservations,
      page: () => MyObservationsScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

// Middleware para verificar la autenticación
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Obtener el controlador de autenticación
    final authController = Get.find<AuthController>();
    
    // Si el usuario no está autenticado, redirigir al login
    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    // Si está autenticado, permitir el acceso a la ruta solicitada
    return null;
  }
}
