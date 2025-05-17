import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // Valores por defecto para desarrollo
  static const String _devSupabaseUrl = 'https://iftsroiviuwuxgcaodoq.supabase.co';
  static const String _devSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmdHNyb2l2aXV3dXhnY2FvZG9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxNjM5MTEsImV4cCI6MjA2MjczOTkxMX0.aFHUf_8ui8pUTmLvdl3PV_2-L6bmosxkuQtqAh0Y9S8';
  
  // No hardcodeamos valores de producción - se deben proporcionar mediante variables de entorno
  
  // URLs de redirección para autenticación OAuth
  // Para dispositivos móviles (mismo esquema para ambos entornos)
  static const String redirectUrl = 'io.supabase.flutter://login-callback/';
  
  // Para desarrollo web local (puerto 3000)
  static const String _devWebRedirectUrl = 'http://localhost:3000';
  
  // URL de redirección para navegadores web en producción
  // No hardcodeamos valores de producción - se deben proporcionar mediante variables de entorno
  
  // Obtener URL de Supabase (con fallback a desarrollo)
  static String get supabaseUrl {
    // Intentar leer de variables de entorno
    final envUrl = const String.fromEnvironment('SUPABASE_URL');
    if (envUrl.isNotEmpty) {

      return envUrl;
    }
    
    // Verificar si estamos en modo de producción
    final isProd = const bool.fromEnvironment('PROD_MODE', defaultValue: false);
    if (isProd) {


      return 'https://szbysmxkohlfqypitvyw.supabase.co';
    }
    
    // Valor por defecto para desarrollo
    return _devSupabaseUrl;
  }
  
  // Obtener clave anónima (con fallback a desarrollo)
  static String get supabaseAnonKey {
    // Intentar leer de variables de entorno
    final envKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
    if (envKey.isNotEmpty) {

      return envKey;
    }
    
    // Verificar si estamos en modo de producción
    final isProd = const bool.fromEnvironment('PROD_MODE', defaultValue: false);
    if (isProd) {


      return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN6YnlzbXhrb2hsZnF5cGl0dnl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0MzA0OTgsImV4cCI6MjA2MzAwNjQ5OH0.0RmS9Tz8ZC5bJx26QWhRouSigwHq_ZfU7YDKoc5mjx4';
    }
    
    // Valor por defecto para desarrollo
    return _devSupabaseAnonKey;
  }
  
  // Determinar la URL de redirección adecuada según la plataforma
  static String getRedirectUrl() {
    // En dispositivos móviles, siempre usar el esquema personalizado
    if (!kIsWeb) {
      return redirectUrl;
    }
    
    // Intentar leer de variables de entorno
    final envRedirectUrl = const String.fromEnvironment('WEB_REDIRECT_URL');
    if (envRedirectUrl.isNotEmpty) {

      return envRedirectUrl;
    }
    
    // Verificar si estamos en modo de producción
    final isProd = const bool.fromEnvironment('PROD_MODE', defaultValue: false);
    if (isProd) {


      // SOLUCIÓN TEMPORAL: Usar un valor predeterminado para producción
      return 'https://insectlab.app';
    }
    
    // Valor por defecto para desarrollo web local
    return _devWebRedirectUrl;
  }
  
  // Método para imprimir la configuración actual (para depuración)
  static void printConfig() {




  }
}
