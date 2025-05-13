import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/loading_indicator.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/home/insectlab_logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Subtítulo
                    Text(
                      'login_subtitle'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Formulario de login
                    Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Campo de email
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.grey[800]),
                              decoration: InputDecoration(
                                labelText: 'email'.tr,
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: AppTheme.calPolyGreen),
                                ),
                                prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            
                            // Campo de contraseña
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: Colors.grey[800]),
                              decoration: InputDecoration(
                                labelText: 'password'.tr,
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: AppTheme.calPolyGreen),
                                ),
                                prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                              ),
                              obscureText: true,
                            ),
                            
                            // Mensaje de error
                            Obx(() => _authController.errorMessage.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      _authController.errorMessage.value,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox.shrink()),
                            
                            // Olvidé mi contraseña
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.calPolyGreen,
                                ),
                                child: Text('forgot_password'.tr),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botón de login
                    Obx(() => ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () => _login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.emerald,
                            foregroundColor: AppTheme.calPolyGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _authController.isLoading.value
                              ? const LoadingIndicator(size: 24)
                              : Text(
                                  'login'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )),
                    
                    const SizedBox(height: 24),
                    
                    // Separador
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'o'.tr,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botón de Google (solo logo)
                    Center(
                      child: Container(
                        height: 48,
                        width: 48,
                        child: OutlinedButton(
                          onPressed: () => _authController.signInWithGoogle(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.calPolyGreen,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: AppTheme.calPolyGreen),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/login/google_logo.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_account'.tr,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.register),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.calPolyGreen,
                          ),
                          child: Text('register'.tr),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      _authController.errorMessage.value = 'complete_fields'.tr;
      return;
    }
    
    _authController.signInWithEmail(email, password);
  }
}
