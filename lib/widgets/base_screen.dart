import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_selector.dart';
import '../controllers/auth_controller.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showDrawer;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBody;
  final bool showLanguageSelector; // Nueva propiedad para controlar la visibilidad del selector de idioma
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Método estático para mostrar el diálogo de confirmación de cierre de sesión
  static void _showLogoutDialog(BuildContext context, AuthController authController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400, // Limitar el ancho máximo
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // 90% del ancho en móvil
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de alerta
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red[700],
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                // Título
                Text(
                  'logout_confirmation'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Mensaje
                Text(
                  'logout_message'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de cancelar
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón de cerrar sesión
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          authController.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'logout'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BaseScreen({
    super.key,
    required this.child,
    this.title,
    this.showDrawer = true,
    this.actions,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBody = false,
    this.showLanguageSelector = true, // Por defecto, mostrar el selector de idioma
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      extendBody: extendBody,
      appBar: AppBar(
        leading: showDrawer
            ? IconButton(
                icon: const Icon(Icons.menu, color: Colors.green),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        title: title != null ? Text(title!.tr) : null,
        actions: [
          // Solo mostrar el selector de idioma si showLanguageSelector es true
          if (showLanguageSelector) const LanguageSelector(),
          if (actions != null) ...actions!,
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      drawer: showDrawer ? BaseScreen.buildDrawer(context) : null,
    );
  }

  static Widget buildDrawer(BuildContext context) {
    // Obtener el controlador de autenticación
    final AuthController authController = Get.find<AuthController>();
    
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withGreen(100),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/home/insectlab_logo.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'app_title'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'app_subtitle'.tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('home'.tr),
              subtitle: Text('main_page'.tr),
              onTap: () {
                Get.back();
                Get.offNamed('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text('insect_search'.tr),
              subtitle: Text('database'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/insect-search');
              },
            ),
            ListTile(
              leading: const Icon(Icons.science),
              title: Text('rna'.tr),
              subtitle: Text('biological_control'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/rna');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pest_control),
              title: Text('key_insects'.tr),
              subtitle: Text('important_species'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/key-insects');
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: Text('mapa_insectos'.tr),
              subtitle: Text('buscar_insectos'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/insect-map');
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections_bookmark),
              title: Text('mis_observaciones'.tr),
              subtitle: Text('gestionar_observaciones'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/my-observations');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: Text('asistente_virtual'.tr),
              subtitle: Text('entomologia_chat'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/chatbot');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text('about'.tr),
              subtitle: Text('about_app'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('account_settings'.tr),
              subtitle: Text('manage_account'.tr),
              onTap: () {
                Get.back();
                Get.toNamed('/account-settings');
              },
            ),
            // Divisor antes del botón de cerrar sesión
            const Divider(),
            
            // Botón de cerrar sesión
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
              onTap: () {
                Get.back(); // Cerrar el drawer
                _showLogoutDialog(context, authController); // Mostrar diálogo de confirmación
              },
            ),
            
            // Comentado para el próximo release
          // ListTile(
          //   leading: const Icon(Icons.games),
          //   title: Text('educational_games'.tr),
          //   subtitle: Text('learn_by_playing'.tr),
          //   onTap: () {
          //     Get.back();
          //     Get.toNamed('/games');
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.camera_alt),
          //   title: Text('prediction'.tr),
          //   subtitle: Text('identify_insects'.tr),
          //   onTap: () {
          //     Get.back();
          //     Get.toNamed('/identification');
          //   },
          // ),
          ],
        ),
      ),
    );
  }
}
