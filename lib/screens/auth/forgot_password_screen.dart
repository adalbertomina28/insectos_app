import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/loading_indicator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('forgot_password'.tr),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono
                  const Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  
                  // Título
                  Text(
                    'reset_password'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Instrucciones
                  Text(
                    'reset_password_instructions'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Campo de email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email'.tr,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                  
                  const SizedBox(height: 32),
                  
                  // Botón de enviar
                  Obx(() => ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : () => _resetPassword(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _authController.isLoading.value
                            ? const LoadingIndicator(size: 24)
                            : Text(
                                'send'.tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                      )),
                  
                  const SizedBox(height: 16),
                  
                  // Volver al login
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('back_to_login'.tr),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      _authController.errorMessage.value = 'enter_email'.tr;
      return;
    }
    
    // Validar formato de email
    if (!GetUtils.isEmail(email)) {
      _authController.errorMessage.value = 'invalid_email'.tr;
      return;
    }
    
    _authController.resetPassword(email);
  }
}
