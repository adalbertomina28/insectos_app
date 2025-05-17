import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_routes.dart';
import '../config/supabase_config.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  
  // Variables observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isAuthenticated = false.obs;
  final user = Rxn<User>();
  
  // Getter para acceder al usuario actual
  Rxn<User> get currentUser => user;
  
  @override
  void onInit() {
    super.onInit();
    // Verificar si hay una sesión activa al iniciar
    _checkCurrentSession();
    
    // Escuchar cambios en la autenticación
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn) {
        user.value = session?.user;
        isAuthenticated.value = true;
      } else if (event == AuthChangeEvent.signedOut) {
        user.value = null;
        isAuthenticated.value = false;
      }
    });
  }
  
  // Verificar si hay una sesión activa
  void _checkCurrentSession() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      user.value = session.user;
      isAuthenticated.value = true;
    }
  }
  
  // Iniciar sesión con correo y contraseña
  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Redirigir al home si la autenticación es exitosa
      Get.offAllNamed(AppRoutes.home);
    } on AuthException catch (e) {
      // Manejar códigos de error específicos para mejorar la experiencia del usuario
      switch (e.message) {
        case 'Invalid login credentials':
          errorMessage.value = 'Correo o contraseña incorrectos. Por favor, verifica tus datos.';
          break;
        case 'Email not confirmed':
          errorMessage.value = 'Tu correo electrónico no ha sido confirmado. Por favor, revisa tu bandeja de entrada.';
          break;
        case 'User not found':
          errorMessage.value = 'No existe una cuenta con este correo electrónico. ¿Quieres registrarte?';
          break;
        case 'Too many requests':
          errorMessage.value = 'Demasiados intentos fallidos. Por favor, intenta más tarde.';
          break;
        default:
          errorMessage.value = 'Error al iniciar sesión: ${e.message}';
      }
    } catch (e) {
      // Manejar errores generales
      if (e.toString().contains('network')) {
        errorMessage.value = 'Error de conexión. Verifica tu conexión a internet.';
      } else {
        errorMessage.value = 'Error al iniciar sesión. Por favor, intenta nuevamente.';
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  // Registrar un nuevo usuario
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      
      // Mostrar mensaje de verificación de correo
      Get.snackbar(
        'Registro exitoso',
        'Se ha enviado un correo de verificación a $email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on AuthException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Error al registrar: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Iniciar sesión con Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Obtener la URL de redirección adecuada según la plataforma
      final redirectUrl = SupabaseConfig.getRedirectUrl();

      
      // Usar el flujo PKCE para la autenticación con Google
      final res = await _supabase.auth.signInWithOAuth(
        Provider.google,
        redirectTo: redirectUrl,
        queryParams: {
          'access_type': 'offline',
          'prompt': 'consent',
        },
      );
      
      // Verificar si la autenticación se inició correctamente
      if (!res) {
        errorMessage.value = 'No se pudo iniciar el proceso de autenticación con Google';
      } else {

        if (kIsWeb) {

        } else {

        }
      }
    } catch (e) {

      errorMessage.value = 'Error al iniciar sesión con Google: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cerrar sesión
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _supabase.auth.signOut();
      Get.offAllNamed(AppRoutes.login); // Redirigir a la pantalla de login
    } catch (e) {
      errorMessage.value = 'Error al cerrar sesión: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _supabase.auth.resetPasswordForEmail(email);
      
      // Mostrar un mensaje de éxito con estilo mejorado
      Get.snackbar(
        'Correo enviado',
        'Hemos enviado un enlace a $email con instrucciones para restablecer tu contraseña',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        margin: const EdgeInsets.all(16),
        borderRadius: 10,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      
      // Regresar a la pantalla de login después de mostrar el mensaje
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } on AuthException catch (e) {
      // Manejar errores específicos de autenticación
      if (e.message.contains('rate limit')) {
        errorMessage.value = 'Has solicitado demasiados enlaces recientemente. Por favor, espera unos minutos e intenta nuevamente.';
      } else if (e.message.contains('user not found')) {
        errorMessage.value = 'No encontramos una cuenta con este correo electrónico. Verifica que sea correcto.';
      } else {
        errorMessage.value = 'Error al enviar el correo: ${e.message}';
      }
    } catch (e) {
      // Manejar errores generales
      if (e.toString().contains('network')) {
        errorMessage.value = 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      } else {
        errorMessage.value = 'No pudimos procesar tu solicitud. Por favor, intenta más tarde.';
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  // Establecer la sesión del usuario
  void setSession(Session session) {
    try {

      user.value = session.user;
      isAuthenticated.value = true;
      
      // Usar un enfoque más seguro para la navegación
      // En lugar de navegar inmediatamente, dejamos que el callback onInit en GetMaterialApp
      // maneje la navegación cuando la aplicación esté completamente inicializada

      
      // Si la aplicación ya está inicializada, podemos intentar navegar con un pequeño retraso
      if (Get.context != null) {

        Future.delayed(Duration(milliseconds: 300), () {
          Get.offAllNamed(AppRoutes.home);
        });
      }
    } catch (e) {

    }
  }
  
  // Actualizar metadatos del usuario
  Future<void> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _supabase.auth.updateUser(
        UserAttributes(
          data: metadata,
        ),
      );
      
      // Actualizar el usuario local
      final currentSession = _supabase.auth.currentSession;
      if (currentSession != null) {
        user.value = currentSession.user;
      }
      
      return Future.value();
    } catch (e) {
      errorMessage.value = 'Error al actualizar perfil: $e';
      throw e;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Procesar código de autenticación (para Deep Links en dispositivos móviles)
  Future<void> processAuthCode(String code) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Registrar en la consola para depuración

      
      // Intercambiar el código por una sesión
      final response = await _supabase.auth.exchangeCodeForSession(code);
      
      // Verificar si se obtuvo una sesión válida
      if (response.session != null) {

        setSession(response.session!);
      } else {

        errorMessage.value = 'Error de autenticación: No se pudo crear una sesión';
      }
    } catch (e) {

      errorMessage.value = 'Error al procesar la autenticación: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
