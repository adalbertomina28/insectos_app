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
                  color: AppTheme.calPolyGreen.withOpacity(0.5),
                ),
                // Contenido del header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra superior con menú y selector de idioma
                      SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            const LanguageSelector(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Título centrado
                      Center(
                        child: Text(
                          'account_settings'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: AppTheme.backgroundColor,
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
                        // Sección de perfil
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
                                  'profile_info'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'name'.tr,
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
                                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'name_required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white70), // Color más claro para indicar que es de solo lectura
                                  decoration: InputDecoration(
                                    labelText: 'email'.tr,
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    helperText: 'email_cannot_be_changed'.tr,
                                    helperStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white60),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white60),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white60),
                                    ),
                                    prefixIcon: const Icon(Icons.email, color: Colors.white60),
                                    suffixIcon: const Icon(Icons.lock, color: Colors.white60, size: 16), // Icono de candado para indicar que está bloqueado
                                  ),
                                  readOnly: true,
                                  enabled: false, // Deshabilitado completamente
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sección de seguridad
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
                                  'security'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.lock, color: Colors.white),
                                  title: Text(
                                    'change_password'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                                  onTap: () {
                                    // Implementar cambio de contraseña
                                    Get.toNamed('/change-password');
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
                            onPressed: _isLoading ? null : _updateUserProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.calPolyGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'save_changes'.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
