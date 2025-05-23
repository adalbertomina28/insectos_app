import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insectos_app/controllers/observation_controller.dart';
import 'package:insectos_app/models/observation_model.dart';
import 'package:insectos_app/widgets/base_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyObservationsScreen extends StatelessWidget {
  final ObservationController controller = Get.put(ObservationController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyObservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('mis_observaciones'.tr),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshObservations(),
            tooltip: 'refresh'.tr,
          ),
        ],
      ),
      drawer: BaseScreen.buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/create-observation');
        },
        child: const Icon(Icons.add),
        tooltip: 'crear_observacion'.tr,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[300]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshObservations(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.observations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'no_observations'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'create_observation_prompt'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshObservations,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.observations.length,
            itemBuilder: (context, index) {
              final observation = controller.observations[index];
              return _buildObservationCard(context, observation);
            },
          ),
        );
      }),
    );
  }

  Widget _buildObservationCard(BuildContext context, Observation observation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navegar a la pantalla de detalle de la observación
          _showObservationDetails(context, observation);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildObservationImage(observation),
              ),
            ),
            
            // Información de la observación
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre científico
                  Text(
                    observation.scientificName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  // Nombre común si existe
                  if (observation.commonName != null && observation.commonName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        observation.commonName!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Fecha de observación
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        observation.formattedDate,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${observation.latitude.toStringAsFixed(4)}, ${observation.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  // Descripción corta si existe
                  if (observation.description != null && observation.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        observation.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Acciones
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón para ver detalles
                  TextButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: Text('view_details'.tr),
                    onPressed: () {
                      _showObservationDetails(context, observation);
                    },
                  ),
                  
                  // Botón para eliminar
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text('delete'.tr, style: const TextStyle(color: Colors.red)),
                    onPressed: () {
                      _confirmDelete(context, observation);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationImage(Observation observation) {
    if (observation.photos.isEmpty) {
      // Imagen por defecto si no hay fotos
      return Image.asset(
        'images/vectors/no_image_attached.png',
        fit: BoxFit.cover,
      );
    }

    // Usar la primera foto de la observación
    return CachedNetworkImage(
      imageUrl: observation.photos.first.photoUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'images/vectors/no_image_attached.png',
        fit: BoxFit.cover,
      ),
    );
  }

  void _showObservationDetails(BuildContext context, Observation observation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado con nombre científico
                    Center(
                      child: Text(
                        observation.scientificName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // Nombre común si existe
                    if (observation.commonName != null && observation.commonName!.isNotEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            observation.commonName!,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Galería de fotos
                    if (observation.photos.isNotEmpty)
                      _buildPhotoGallery(observation),
                    
                    const SizedBox(height: 24),
                    
                    // Información detallada
                    _buildDetailItem(
                      Icons.calendar_today,
                      'observation_date'.tr,
                      observation.formattedDate,
                    ),
                    
                    _buildDetailItem(
                      Icons.location_on,
                      'location'.tr,
                      '${observation.latitude.toStringAsFixed(6)}, ${observation.longitude.toStringAsFixed(6)}',
                    ),
                    
                    // Descripción completa si existe
                    if (observation.description != null && observation.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'description'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              observation.description!,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Botones de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: Text('delete'.tr),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _confirmDelete(context, observation);
                          },
                        ),
                        
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: Text('close'.tr),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhotoGallery(Observation observation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'photos'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: observation.photos.length,
            itemBuilder: (context, index) {
              final photo = observation.photos[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      // Mostrar la imagen a pantalla completa
                      _showFullScreenImage(context, photo.photoUrl);
                    },
                    child: CachedNetworkImage(
                      imageUrl: photo.photoUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, size: 48),
                  ),
                ),
              ),
              
              // Botón para cerrar
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Observation observation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('confirm_delete'.tr),
          content: Text('delete_observation_confirmation'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await controller.deleteObservation(observation.id);
                
                if (success) {
                  Get.snackbar(
                    'success'.tr,
                    'observation_deleted'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'error'.tr,
                    'delete_error'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('delete'.tr, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
