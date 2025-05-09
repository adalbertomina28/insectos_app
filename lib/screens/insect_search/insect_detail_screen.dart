import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../controllers/insect_controller.dart';
import '../../models/insect_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_selector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class InsectDetailScreen extends GetView<InsectController> {
  final Insect? insect;

  const InsectDetailScreen({
    super.key,
    this.insect,
  });

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo abrir el enlace',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método para lanzar una URL alternativa cuando no hay enlace directo a Wikipedia
  Future<void> _launchAlternativeUrl(Insect? insect) async {
    // Si el insecto es nulo, no hacer nada
    if (insect == null) return;
    // Si hay un enlace directo a Wikipedia, usarlo
    if (insect.wikipediaUrl != null) {
      await _launchUrl(insect.wikipediaUrl);
      return;
    }

    // Determinar el mejor término de búsqueda
    String searchTerm;

    // Preferir el nombre científico si está disponible
    if (insect.scientificName != null && insect.scientificName!.isNotEmpty) {
      searchTerm = insect.scientificName!;
    }
    // Si no, usar el nombre común preferido
    else if (insect.preferredCommonName != null &&
        insect.preferredCommonName!.isNotEmpty) {
      searchTerm = insect.preferredCommonName!;
    }
    // Como última opción, usar el nombre básico
    else {
      searchTerm = insect.name;
    }

    // Añadir "insecto" al término de búsqueda para mejorar los resultados
    searchTerm = Uri.encodeComponent('insecto $searchTerm');

    // Crear URL para búsqueda en Google
    final googleUrl = 'https://www.google.com/search?q=$searchTerm';

    // Redirigir directamente a Google
    await _launchUrl(googleUrl);
  }

  @override
  Widget build(BuildContext context) {
    // Si el insecto es nulo, redirigir a la pantalla de búsqueda
    if (insect == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/insect-search');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInsectDetails(insect!.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(insect!.preferredCommonName ?? insect!.name),
        elevation: 0,
        actions: const [
          LanguageSelector(),
          SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.error.value,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        }

        final selectedInsect = controller.selectedInsect.value;
        if (selectedInsect == null) {
          return const Center(
            child: Text('No se encontraron detalles del insecto'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedInsect.defaultPhoto != null)
                CachedNetworkImage(
                  imageUrl: selectedInsect.defaultPhoto!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedInsect.preferredCommonName ?? selectedInsect.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (selectedInsect.scientificName != null)
                      Text(
                        selectedInsect.scientificName!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (selectedInsect.wikipediaSummary != null) ...[
                      Text(
                        'description'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Html(
                        data: selectedInsect.wikipediaSummary!,
                        style: {
                          "body": Style(
                            fontSize: FontSize(16),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (selectedInsect.ancestorTaxa != null) ...[
                      Text(
                        'classification'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedInsect.ancestorTaxa!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Botón "Aprende más" - funciona con o sin enlace directo a Wikipedia
                    ElevatedButton.icon(
                      onPressed: () => _launchAlternativeUrl(selectedInsect),
                      icon: const Icon(Icons.open_in_new),
                      label: Text('learn_more'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
