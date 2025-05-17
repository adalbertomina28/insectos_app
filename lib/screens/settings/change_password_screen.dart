import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insectos_app/controllers/auth_controller.dart';
import 'package:insectos_app/theme/app_theme.dart';
import 'package:insectos_app/widgets/base_screen.dart';
import 'package:insectos_app/widgets/language_selector.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'passwords_do_not_match'.tr;
      });
      
      Get.snackbar(
        'error'.tr,
        _errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Aquí implementaríamos la lógica para cambiar la contraseña
      // Por ahora, mostraremos un mensaje de éxito simulado
      
      // Simulación de cambio de contraseña exitoso
      await Future.delayed(const Duration(seconds: 1));
      
      Get.snackbar(
        'success'.tr,
        'password_changed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Volver a la pantalla anterior después de cambiar la contraseña
      Get.back();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      
      Get.snackbar(
        'error'.tr,
        _errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: BaseScreen.buildDrawer(context),
      body: Column(
        children: [
          // Header con diseño moderno
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                // Barra superior con menú y selector de idioma
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: AppTheme.calPolyGreen,
                              size: 28,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                        const LanguageSelector(),
                      ],
                    ),
                  ),
                ),
                // Imagen de configuración
                Image.asset(
                  'images/vectors/configuration.png',
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {

                    return Container(
                      height: 180,
                      width: 180,
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.lock,
                        size: 64,
                        color: AppTheme.calPolyGreen.withOpacity(0.5),
                      ),
                    );
                  },
                ),
                // Título centrado
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'change_password'.tr,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Obx(() {
                final user = _authController.currentUser.value;
                
                if (user == null) {
                  return Center(
                    child: Text(
                      'not_logged_in'.tr,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  );
                }
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Formulario de cambio de contraseña
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: AppTheme.calPolyGreen.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título de la sección
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.calPolyGreen.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: AppTheme.calPolyGreen,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'change_password'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Para cambiar tu contraseña, ingresa tu contraseña actual y luego la nueva contraseña dos veces para confirmarla.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Campo de contraseña actual
                                TextFormField(
                                  controller: _currentPasswordController,
                                  obscureText: _obscureCurrentPassword,
                                  decoration: InputDecoration(
                                    labelText: 'current_password'.tr,
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen.withOpacity(0.3)),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureCurrentPassword = !_obscureCurrentPassword;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  style: TextStyle(color: Colors.grey[800]),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'current_password_required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Campo de nueva contraseña
                                TextFormField(
                                  controller: _newPasswordController,
                                  obscureText: _obscureNewPassword,
                                  decoration: InputDecoration(
                                    labelText: 'new_password'.tr,
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen.withOpacity(0.3)),
                                    ),
                                    prefixIcon: Icon(Icons.vpn_key_outlined, color: Colors.grey[600]),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPassword = !_obscureNewPassword;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  style: TextStyle(color: Colors.grey[800]),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'new_password_required'.tr;
                                    }
                                    if (value.length < 6) {
                                      return 'change_password_too_short'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                
                                // Campo de confirmación de contraseña
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'change_confirm_password'.tr,
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen.withOpacity(0.3)),
                                    ),
                                    prefixIcon: Icon(Icons.check_circle_outline, color: Colors.grey[600]),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  style: TextStyle(color: Colors.grey[800]),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'change_confirm_password_required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Botón de guardar cambios
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.calPolyGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'change_password'.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        // Mensaje de error
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
