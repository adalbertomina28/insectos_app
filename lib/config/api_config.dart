class ApiConfig {
  // Para emulador Android usar 10.0.2.2 en lugar de localhost
  // Para dispositivos físicos, usar la IP de tu computadora en la red local
  static const String baseUrl =
      'http://t0gsggssgg8ow04ocwww08oo.195.35.36.123.sslip.io'; // URL para emulador Android
  // static const String baseUrl = 'http://192.168.1.X:8000';  // Reemplaza X con tu IP local para dispositivos físicos

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
