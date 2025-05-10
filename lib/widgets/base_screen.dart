import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'language_selector.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showDrawer;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBody;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BaseScreen({
    super.key,
    required this.child,
    this.title,
    this.showDrawer = true,
    this.actions,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBody = false,
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
          const LanguageSelector(),
          if (actions != null) ...actions!,
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      drawer: showDrawer ? BaseScreen.buildDrawer(context) : null,
    );
  }

  static Widget buildDrawer(BuildContext context) {
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
                Get.offNamed('/');
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
