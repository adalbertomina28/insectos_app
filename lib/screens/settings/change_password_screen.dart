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
          // Header con imagen de fondo
          Container(
            height: 200,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen de fondo
                Image.asset(
                  'assets/images/home/insect_search.jpg',
                  fit: BoxFit.cover,
                ),
                // Overlay para mejorar la legibilidad del texto
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                // Contenido del header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila superior con botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Botón de menú hamburguesa
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          // Selector de idioma
                          const LanguageSelector(),
                        ],
                      ),
                      // Título de la pantalla
                      Text(
                        'change_password'.tr,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Container(
              color: AppTheme.cardColor,
              child: Obx(() {
                final user = _authController.currentUser.value;
                
                if (user == null) {
                  return Center(
                    child: Text(
                      'not_logged_in'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Formulario de cambio de contraseña
                        Card(
                          elevation: 2,
                          color: AppTheme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'password_change_instructions'.tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Campo de contraseña actual
                                TextFormField(
                                  controller: _currentPasswordController,
                                  obscureText: _obscureCurrentPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'current_password'.tr,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen),
                                    ),
                                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureCurrentPassword = !_obscureCurrentPassword;
                                        });
                                      },
                                    ),
                                  ),
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
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'new_password'.tr,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen),
                                    ),
                                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPassword = !_obscureNewPassword;
                                        });
                                      },
                                    ),
                                  ),
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
                                const SizedBox(height: 16),
                                
                                // Campo de confirmación de contraseña
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'change_confirm_password'.tr,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppTheme.calPolyGreen),
                                    ),
                                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
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
                        
                        const SizedBox(height: 24),
                        
                        // Botón de guardar cambios
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.calPolyGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
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
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
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
