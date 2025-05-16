import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/insect_controller.dart';
import '../../models/insect_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/language_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'insect_detail_screen.dart';

class InsectSearchScreen extends StatelessWidget {
  InsectSearchScreen({super.key});

  final InsectController controller = Get.find<InsectController>();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: AppTheme.calPolyGreen,
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
                ),
                
                // Espacio para la barra superior
                const SizedBox(height: 16),
                
                // Imagen del insecto de búsqueda
                Image.asset(
                  'images/vectors/busqueda_insecto.png', // Cambiado de assets/images a images
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error al cargar la imagen: $error');
                    return Container(
                      height: 180,
                      width: 180,
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.bug_report,
                        size: 64,
                        color: AppTheme.calPolyGreen.withOpacity(0.5),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Título principal
                Text(
                  'search_screen_title'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.calPolyGreen,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Campo de búsqueda mejorado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: Colors.grey[800]),
                        decoration: InputDecoration(
                          hintText: 'search_hint'.tr,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(Icons.search, color: AppTheme.calPolyGreen),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[400]),
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.calPolyGreen.withOpacity(0.3), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.calPolyGreen.withOpacity(0.3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppTheme.calPolyGreen, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            controller.searchInsects(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.calPolyGreen),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'loading'.tr,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        );
                      }

                      if (controller.error.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red[400],
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'error_loading'.tr,
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      if (controller.searchResults.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                color: Colors.grey[400],
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'no_results'.tr,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8)
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.searchResults.length,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemBuilder: (context, index) {
                          final insect = controller.searchResults[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: AppTheme.calPolyGreen.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => InsectDetailScreen(insect: insect));
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Row(
                                children: [
                                  // Imagen del insecto
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: insect.defaultPhoto ?? '',
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 110,
                                        height: 110,
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.bug_report,
                                          color: Colors.grey[400],
                                          size: 32,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        width: 110,
                                        height: 110,
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.grey[400],
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Información del insecto
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Nombre común preferido
                                          Text(
                                            insect.preferredCommonName ?? insect.name,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                              letterSpacing: -0.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          // Nombre científico (si está disponible)
                                          if (insect.scientificName != null)
                                            Text(
                                              insect.scientificName!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 8)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Icono de flecha para indicar que se puede tocar
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
