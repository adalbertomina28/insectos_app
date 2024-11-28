import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../controllers/insect_controller.dart';
import '../../models/insect_model.dart';
import '../../theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class InsectDetailScreen extends GetView<InsectController> {
  final Insect insect;

  const InsectDetailScreen({
    super.key,
    required this.insect,
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getInsectDetails(insect.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(insect.preferredCommonName ?? insect.name),
        elevation: 0,
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
                      const Text(
                        'Descripción',
                        style: TextStyle(
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
                      const Text(
                        'Clasificación',
                        style: TextStyle(
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
                    if (selectedInsect.wikipediaUrl != null)
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl(selectedInsect.wikipediaUrl),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Ver en Wikipedia'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.calPolyGreen,
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
