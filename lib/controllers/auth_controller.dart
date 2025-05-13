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
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Error al iniciar sesión: $e';
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
      print('Usando URL de redirección: $redirectUrl');
      
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
        print('Proceso de autenticación con Google iniciado correctamente');
        if (kIsWeb) {
          print('En modo web, la sesión se manejará automáticamente cuando se reciba la redirección');
        } else {
          print('En modo móvil, espera a ser redirigido de vuelta a la aplicación...');
        }
      }
    } catch (e) {
      print('Error detallado al iniciar sesión con Google: $e');
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
      
      Get.snackbar(
        'Recuperación de contraseña',
        'Se ha enviado un correo a $email con instrucciones para recuperar tu contraseña',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Error al recuperar contraseña: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Establecer la sesión del usuario
  void setSession(Session session) {
    try {
      print('Estableciendo sesión para el usuario');
      user.value = session.user;
      isAuthenticated.value = true;
      
      // Usar un enfoque más seguro para la navegación
      // En lugar de navegar inmediatamente, dejamos que el callback onInit en GetMaterialApp
      // maneje la navegación cuando la aplicación esté completamente inicializada
      print('Sesión establecida correctamente, la navegación se manejará automáticamente');
      
      // Si la aplicación ya está inicializada, podemos intentar navegar con un pequeño retraso
      if (Get.context != null) {
        print('Contexto disponible, intentando navegación directa');
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offAllNamed(AppRoutes.home);
        });
      }
    } catch (e) {
      print('Error al establecer la sesión: $e');
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
      print('Procesando código de autenticación: $code');
      
      // Intercambiar el código por una sesión
      final response = await _supabase.auth.exchangeCodeForSession(code);
      
      // Verificar si se obtuvo una sesión válida
      if (response.session != null) {
        print('Sesión creada exitosamente');
        setSession(response.session!);
      } else {
        print('No se pudo crear una sesión con el código proporcionado');
        errorMessage.value = 'Error de autenticación: No se pudo crear una sesión';
      }
    } catch (e) {
      print('Error al procesar el código de autenticación: $e');
      errorMessage.value = 'Error al procesar la autenticación: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
