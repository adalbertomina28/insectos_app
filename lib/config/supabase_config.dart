import 'package:flutter/foundation.dart';

class SupabaseConfig {
  // Credenciales de Supabase
  static const String supabaseUrl = 'https://iftsroiviuwuxgcaodoq.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmdHNyb2l2aXV3dXhnY2FvZG9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxNjM5MTEsImV4cCI6MjA2MjczOTkxMX0.aFHUf_8ui8pUTmLvdl3PV_2-L6bmosxkuQtqAh0Y9S8';
  
  // URLs de redirección para autenticación OAuth
  // Para dispositivos móviles
  static const String redirectUrl = 'io.supabase.flutter://login-callback/';
  
  // Para desarrollo web local (puerto 3000)
  static const String webLocalRedirectUrl = 'http://localhost:3000';
  
  // URL de redirección para navegadores web en producción
  static const String webRedirectUrl = 'https://iftsroiviuwuxgcaodoq.supabase.co/auth/v1/callback';
  
  // Determinar la URL de redirección adecuada según la plataforma
  static String getRedirectUrl() {
    if (kIsWeb) {
      // Si estamos en web, usar la URL local durante desarrollo
      return webLocalRedirectUrl;
    } else {
      // En dispositivos móviles, usar el esquema personalizado
      return redirectUrl;
    }
  }
}
