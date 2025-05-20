import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:html' if (dart.library.io) 'dart:io' show window;
import 'package:url_launcher/url_launcher.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'dart:convert';
import '../models/auth_models.dart';

class AuthController extends GetxController {
  // Servicio de autenticación
  final _authService = AuthService();
  
  // Variables observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isAuthenticated = false.obs;
  final user = Rxn<User>();
  
  // Variables para almacenar la sesión
  final _session = Rxn<Session>();
  final _accessToken = RxString('');
  final _refreshToken = RxString('');
  
  // Getter para acceder al usuario actual
  Rxn<User> get currentUser => user;
  
  // Getter para el token de acceso
  String get accessToken => _accessToken.value;
  
  @override
  void onInit() {
    super.onInit();
    // Verificar si hay una sesión almacenada localmente
    _checkLocalSession();
  }
  
  // Verificar si hay una sesión almacenada localmente
  Future<void> _checkLocalSession() async {
    // Aquí se implementaría la lógica para recuperar la sesión almacenada localmente
    // Por ejemplo, usando shared_preferences o secure_storage
    // Por ahora, simplemente verificamos si hay una sesión en memoria
    if (_session.value != null) {
      user.value = _session.value?.user;
      isAuthenticated.value = true;
      
      // Refrescar el token si es necesario
      _refreshTokenIfNeeded();
    }
  }
  
  // Refrescar el token si está próximo a expirar
  Future<void> _refreshTokenIfNeeded() async {
    if (_refreshToken.value.isEmpty) return;
    
    try {
      final result = await _authService.refreshToken(_refreshToken.value);
      if (result['success']) {
        final sessionData = result['session'];
        if (sessionData != null) {
          final sessionMap = jsonDecode(sessionData);
          _updateSessionData(sessionMap);
        }
      }
    } catch (e) {
      // Si falla el refresco, cerramos la sesión
      signOut();
    }
  }
  
  // Actualizar los datos de la sesión
  void _updateSessionData(Map<String, dynamic> sessionData) {
    try {
      final userData = sessionData['user'];
      if (userData != null) {
        user.value = User.fromJson(userData);
      }
      
      _accessToken.value = sessionData['access_token'] ?? '';
      _refreshToken.value = sessionData['refresh_token'] ?? '';
      
      // Crear objeto Session
      _session.value = Session(
        accessToken: _accessToken.value,
        refreshToken: _refreshToken.value,
        tokenType: 'bearer',
        user: user.value!,
        expiresIn: sessionData['expires_in'] ?? 3600,
      );
      
      isAuthenticated.value = true;
    } catch (e) {
      errorMessage.value = 'Error al procesar los datos de sesión: $e';
    }
  }
  
  // Iniciar sesión con correo y contraseña
  Future<void> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await _authService.signInWithEmail(email, password);
      
      if (result['success']) {
        // Procesar los datos de la sesión
        final sessionData = result['session'];
        final userData = result['user'];
        
        if (sessionData != null && userData != null) {
          final sessionMap = jsonDecode(sessionData);
          _updateSessionData(sessionMap);
          
          // Redirigir al home si la autenticación es exitosa
          Get.offAllNamed(AppRoutes.home);
        } else {
          errorMessage.value = 'No se pudo obtener la información de sesión';
        }
      } else {
        throw Exception(result['error'] ?? 'Error desconocido');
      }
    } catch (e) {
      // Manejar errores
      final errorMsg = e.toString();
      
      if (errorMsg.contains('Invalid login credentials')) {
        errorMessage.value = 'Correo o contraseña incorrectos. Por favor, verifica tus datos.';
      } else if (errorMsg.contains('Email not confirmed')) {
        errorMessage.value = 'Tu correo electrónico no ha sido confirmado. Por favor, revisa tu bandeja de entrada.';
      } else if (errorMsg.contains('User not found')) {
        errorMessage.value = 'No existe una cuenta con este correo electrónico. ¿Quieres registrarte?';
      } else if (errorMsg.contains('Too many requests')) {
        errorMessage.value = 'Demasiados intentos fallidos. Por favor, intenta más tarde.';
      } else if (errorMsg.contains('network')) {
        errorMessage.value = 'Error de conexión. Verifica tu conexión a internet.';
      } else {
        errorMessage.value = 'Error al iniciar sesión: $errorMsg';
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
      
      final result = await _authService.signUpWithEmail(email, password);
      
      if (result['success']) {
        // Mostrar mensaje de verificación de correo
        Get.snackbar(
          'Registro exitoso',
          'Se ha enviado un correo de verificación a $email',
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Si el registro incluye una sesión activa, procesarla
        final sessionData = result['session'];
        if (sessionData != null) {
          final sessionMap = jsonDecode(sessionData);
          _updateSessionData(sessionMap);
        }
      } else {
        throw Exception(result['error'] ?? 'Error desconocido');
      }
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
      
      // Mostrar mensaje de inicio del proceso
      Get.snackbar(
        'Iniciando',
        'Iniciando autenticación con Google...',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      
      // Determinar la URL de redirección según la plataforma
      final String redirectUrl;
      if (kIsWeb) {
        // Para web, usar la URL de la aplicación
        redirectUrl = Uri.base.toString();
      } else {
        // Para móvil, usar un esquema personalizado
        redirectUrl = 'io.supabase.flutter://login-callback/';
      }
      
      // Obtener la URL de OAuth desde el backend
      final oauthUrl = await _authService.getGoogleOAuthUrl(redirectUrl);
      
      // Abrir la URL en el navegador
      if (kIsWeb) {
        // En web, abrir en la misma ventana
        window.location.href = oauthUrl;
      } else {
        // En móvil, usar el plugin url_launcher
        final Uri uri = Uri.parse(oauthUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('No se pudo abrir la URL: $oauthUrl');
        }
      }
      
      // El resto del proceso será manejado por los Deep Links
      // o por la redirección en web
    } catch (e) {
      errorMessage.value = 'Error al iniciar sesión con Google: $e';
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error al iniciar sesión con Google: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cerrar sesión
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      if (_accessToken.value.isNotEmpty) {
        await _authService.signOut(_accessToken.value);
      }
      
      // Limpiar datos de sesión localmente
      _session.value = null;
      _accessToken.value = '';
      _refreshToken.value = '';
      user.value = null;
      isAuthenticated.value = false;
      
      // Redirigir al login
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = 'Error al cerrar sesión: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _authService.resetPassword(email);
      
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
    } catch (e) {
      // Manejar errores
      final errorMsg = e.toString();
      
      if (errorMsg.contains('rate limit')) {
        errorMessage.value = 'Has solicitado demasiados enlaces recientemente. Por favor, espera unos minutos e intenta nuevamente.';
      } else if (errorMsg.contains('user not found')) {
        errorMessage.value = 'No encontramos una cuenta con este correo electrónico. Verifica que sea correcto.';
      } else if (errorMsg.contains('network')) {
        errorMessage.value = 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      } else {
        errorMessage.value = 'Error al enviar el correo: $errorMsg';
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  // Establecer la sesión del usuario
  void setSession(Map<String, dynamic> sessionData) {
    try {
      // Actualizar los datos de la sesión
      _updateSessionData(sessionData);
      
      // Mostrar mensaje de éxito
      Get.snackbar(
        'Sesión iniciada',
        'Iniciando sesión y redirigiendo...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
      // Forzar la actualización del estado de autenticación
      isAuthenticated.value = true;
      
      // Si la aplicación ya está inicializada, navegar a la pantalla principal
      if (Get.context != null) {
        // Usar un pequeño retraso para asegurar que la UI se actualice primero
        Future.delayed(Duration(milliseconds: 500), () {
          // Forzar la navegación a la pantalla principal
          Get.offAllNamed(AppRoutes.home);
        });
      } else {
        // Si el contexto no está disponible, intentar nuevamente después de un tiempo mayor
        Future.delayed(Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.home);
        });
      }
    } catch (e) {
      errorMessage.value = 'Error al establecer la sesión: $e';
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error al establecer la sesión: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Actualizar metadatos del usuario
  Future<void> updateUserMetadata(Map<String, dynamic> metadata) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      if (_accessToken.value.isEmpty) {
        throw Exception('No hay una sesión activa');
      }
      
      final result = await _authService.updateUserMetadata(_accessToken.value, metadata);
      
      if (result['success']) {
        // Actualizar el usuario local
        final userData = result['user'];
        if (userData != null) {
          final userMap = jsonDecode(userData);
          user.value = User.fromJson(userMap);
        }
      } else {
        throw Exception(result['error'] ?? 'Error desconocido');
      }
      
      return Future.value();
    } catch (e) {
      errorMessage.value = 'Error al actualizar perfil: $e';
      throw e;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Procesar código de autenticación (para Deep Links en dispositivos móviles y web)
  Future<void> processAuthCode(String code) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Mostrar un mensaje de progreso
      Get.snackbar(
        'Procesando',
        'Verificando autenticación con Google...',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      
      // Intercambiar el código por una sesión
      final result = await _authService.exchangeCodeForSession(code);
      
      if (result['success']) {
        // Procesar los datos de la sesión
        final sessionData = result['session'];
        if (sessionData != null) {
          // Convertir los datos de sesión a Map<String, dynamic>
          Map<String, dynamic> sessionMap;
          
          if (sessionData is String) {
            try {
              // Intentar decodificar como JSON si es una cadena
              sessionMap = jsonDecode(sessionData);
            } catch (e) {
              // Si no es JSON válido, crear un mapa simple
              sessionMap = {
                'access_token': sessionData,
                'refresh_token': '',
                'expires_in': 3600,
                'token_type': 'bearer'
              };
            }
          } else if (sessionData is Map) {
            // Ya es un mapa, usarlo directamente
            sessionMap = Map<String, dynamic>.from(sessionData);
          } else {
            // Fallback: crear un mapa con datos básicos
            sessionMap = {
              'access_token': 'token_temporal',
              'refresh_token': '',
              'expires_in': 3600,
              'token_type': 'bearer'
            };
          }
          
          // Mostrar mensaje de éxito
          Get.snackbar(
            'Éxito',
            'Autenticación completada correctamente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
          
          // Actualizar los datos de la sesión
          _updateSessionData(sessionMap);
          
          // Forzar la actualización del estado de autenticación
          isAuthenticated.value = true;
          
          // Navegar a la pantalla principal con un pequeño retraso
          // para asegurar que la UI se actualice primero
          Future.delayed(Duration(milliseconds: 500), () {
            // Si estamos en web, limpiar la URL para eliminar el código
            if (kIsWeb) {
              // Intentar limpiar la URL (esto no funciona en todos los navegadores)
              window.history.pushState({}, '', '/');
            }
            
            // Forzar la navegación a la pantalla principal
            Get.offAllNamed(AppRoutes.home);
          });
        } else {
          errorMessage.value = 'Error de autenticación: No se pudo crear una sesión';
          
          // Mostrar mensaje de error
          Get.snackbar(
            'Error',
            'No se pudo crear una sesión',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Error al intercambiar código: ${result['error']}';
        
        // Mostrar mensaje de error
        Get.snackbar(
          'Error',
          'Error al intercambiar código: ${result['error']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Error al procesar la autenticación: $e';
      
      // Mostrar mensaje de error
      Get.snackbar(
        'Error',
        'Error al procesar la autenticación: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
