import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insectos_app/controllers/auth_controller.dart';
import 'package:insectos_app/theme/app_theme.dart';
import 'package:insectos_app/widgets/base_screen.dart';
import 'package:insectos_app/widgets/language_selector.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  void _loadUserData() {
    final user = _authController.currentUser.value;
    if (user != null) {
      _nameController.text = user.userMetadata?['name'] ?? '';
      _emailController.text = user.email ?? '';
    }
  }
  
  Future<void> _updateUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Actualizar metadatos del usuario
      await _authController.updateUserMetadata({
        'name': _nameController.text.trim(),
      });
      
      Get.snackbar(
        'success'.tr,
        'profile_updated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
                        Icons.settings,
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
                    'account_settings'.tr,
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
                        // Sección de perfil
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
                                        Icons.person,
                                        color: AppTheme.calPolyGreen,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'profile_info'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Campo de nombre
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'name'.tr,
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
                                    prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                                    hintText: 'enter_name'.tr,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  style: TextStyle(color: Colors.grey[800]),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'name_required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Campo de email (solo lectura)
                                TextFormField(
                                  controller: _emailController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'email'.tr,
                                    labelStyle: TextStyle(color: Colors.grey[700]),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Sección de seguridad
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
                                        Icons.security,
                                        color: AppTheme.calPolyGreen,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'security'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Opción de cambio de contraseña
                                InkWell(
                                  onTap: () {
                                    Get.toNamed('/change-password');
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.lock_outline,
                                          color: Colors.grey[700],
                                          size: 22,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            'change_password'.tr,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey[400],
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
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
                            onPressed: _isLoading ? null : _updateUserProfile,
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
                                    'save_changes'.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: const TextStyle(color: Colors.white),
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
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
