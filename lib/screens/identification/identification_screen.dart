import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/identification_controller.dart';
import '../../widgets/base_screen.dart';
import '../../models/identification_result.dart';

class IdentificationScreen extends StatelessWidget {
  final IdentificationController controller = Get.put(IdentificationController());

  IdentificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'insect_identification'.tr,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(context),
              const SizedBox(height: 16),
              _buildActionButtons(context),
              const SizedBox(height: 16),
              _buildLocationToggle(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildResultsSection(context),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: controller.selectedImage.value != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.selectedImage.value!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'select_or_take_photo'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (controller.selectedImage.value != null)
          ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: Text('clear'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: controller.clearImage,
          ),
        ElevatedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: Text('gallery'.tr),
          onPressed: controller.pickImageFromGallery,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: Text('camera'.tr),
          onPressed: controller.takePhoto,
        ),
        if (controller.selectedImage.value != null)
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            label: Text('identify'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: controller.isLoading.value ? null : controller.identifyInsect,
          ),
      ],
    );
  }

  Widget _buildLocationToggle() {
    return Row(
      children: [
        Checkbox(
          value: controller.useLocation.value,
          onChanged: (value) => controller.toggleUseLocation(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'use_location'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'location_improves_accuracy'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (controller.latitude.value != null && controller.longitude.value != null)
          Chip(
            label: Text(
              '${controller.latitude.value?.toStringAsFixed(2) ?? 'N/A'}, ${controller.longitude.value?.toStringAsFixed(2) ?? 'N/A'}',
              style: const TextStyle(fontSize: 10),
            ),
            backgroundColor: Colors.green[100],
            avatar: const Icon(Icons.location_on, size: 14, color: Colors.green),
          ),
      ],
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.hasError.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'error_identifying_insect'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (controller.identificationResult.value != null) {
      final results = controller.identificationResult.value!.results;
      
      if (results.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                color: Colors.amber,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'no_insects_found'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'try_different_image'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'identification_results'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return _buildResultItem(context, result);
              },
            ),
          ),
        ],
      );
    }

    // No hay imagen seleccionada o aún no se ha realizado la identificación
    return controller.selectedImage.value == null
        ? Center(
            child: Text(
              'select_image_to_identify'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ready_to_identify'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: Text('identify_now'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: controller.identifyInsect,
                ),
              ],
            ),
          );
  }

  Widget _buildResultItem(BuildContext context, IdentificationMatch result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => controller.viewInsectDetails(result.taxonId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del insecto
              if (result.photoUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: result.photoUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bug_report,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 16),
              // Información del insecto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.preferredCommonName ?? result.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (result.scientificName != null)
                      Text(
                        result.scientificName!,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Barra de confianza
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'confidence'.tr + ': ',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              result.confidencePercentage,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getConfidenceColor(result.score),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: result.score,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getConfidenceColor(result.score),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Flecha para ver detalles
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getConfidenceColor(double score) {
    if (score >= 0.7) {
      return Colors.green;
    } else if (score >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
