import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:insectos_app/controllers/observation_controller.dart';
import 'package:insectos_app/models/observation_model.dart';
import 'package:insectos_app/widgets/base_screen.dart';
import 'package:insectos_app/widgets/signed_image.dart';

class MyObservationsScreen extends StatelessWidget {
  final ObservationController controller = Get.put(ObservationController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyObservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('my_observations'.tr),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'filter'.tr,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshObservations(),
            tooltip: 'refresh'.tr,
          ),
        ],
      ),
      drawer: BaseScreen.buildDrawer(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create-observation');
        },
        icon: const Icon(Icons.add_a_photo),
        label: Text('new_observation'.tr),
        tooltip: 'create_observation'.tr,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green[800],
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.green[800]!),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'loading_observations'.tr,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                ),
                const SizedBox(height: 16),
                Text(
                  'error_loading_observations'.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshObservations(),
                  icon: const Icon(Icons.refresh),
                  label: Text('retry'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
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
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Text(
                  'no_observations'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'create_observation_prompt'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/create-observation');
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: Text('create_first_observation'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.green[800],
                    elevation: 0,
                    side: BorderSide(color: Colors.green[800]!),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshObservations,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: controller.observations.length,
              itemBuilder: (context, index) {
                final observation = controller.observations[index];
                return _buildObservationCard(context, observation);
              },
            ),
          ),
        );
      }),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'filter_observations'.tr,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption(
                icon: Icons.calendar_today,
                title: 'date'.tr,
                subtitle: 'filter_by_date'.tr,
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtro por fecha
                },
              ),
              const Divider(),
              _buildFilterOption(
                icon: Icons.science_outlined,
                title: 'species'.tr,
                subtitle: 'filter_by_species'.tr,
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtro por especie
                },
              ),
              const Divider(),
              _buildFilterOption(
                icon: Icons.location_on_outlined,
                title: 'location'.tr,
                subtitle: 'filter_by_location'.tr,
                onTap: () {
                  Navigator.pop(context);
                  // Implementar filtro por ubicación
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.refreshObservations();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                  ),
                  child: Text('clear_filters'.tr),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationCard(BuildContext context, Observation observation) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white.withOpacity(0.9), // Fondo casi transparente
      child: InkWell(
        onTap: () => _showObservationDetails(context, observation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal con overlay para información
            Stack(
              children: [
                // Imagen
                Hero(
                  tag: 'observation_image_${observation.id}',
                  child: SizedBox(
                    height: 145, // Reducido de 160 a 145
                    width: double.infinity,
                    child: _buildObservationImage(observation),
                  ),
                ),
                // Overlay con gradiente y nombre científico
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reducido padding vertical
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          observation.scientificName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15, // Reducido de 16 a 15
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (observation.commonName != null && observation.commonName!.isNotEmpty)
                          Text(
                            observation.commonName!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13, // Reducido de 14 a 13
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
                // Fecha en la esquina superior
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(observation.observationDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Información adicional
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reducido padding vertical
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ubicación
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${observation.latitude.toStringAsFixed(4)}, ${observation.longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  // Descripción si existe
                  if (observation.description != null && observation.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4), // Reducido de 8 a 4
                      child: Text(
                        observation.description!,
                        style: TextStyle(
                          fontSize: 12, // Reducido de 13 a 12
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            
            // Botones de acción
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4), // Reducido padding inferior de 8 a 4
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Contador de fotos
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.photo_library, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          observation.photos.length.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botones
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, size: 20),
                        onPressed: () => _showObservationDetails(context, observation),
                        tooltip: 'view_details'.tr,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6), // Reducido de 8 a 6
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
                        onPressed: () => _confirmDelete(context, observation),
                        tooltip: 'delete'.tr,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6), // Reducido de 8 a 6
                      ),
                    ],
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
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: 40,
          ),
        ),
      );
    }

    // Usar la primera foto de la observación con URL firmada
    return SignedImage(
      imageUrl: observation.photos.first.photoUrl,
      fit: BoxFit.cover,
      placeholder: Container(
        color: Colors.grey[100],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'error_loading_image'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showObservationDetails(BuildContext context, Observation observation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.92,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Indicador de arrastre
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Contenido principal
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Imagen principal
                        if (observation.photos.isNotEmpty)
                          GestureDetector(
                            onTap: () => _showFullScreenImage(
                              context, 
                              observation.photos.first.photoUrl
                            ),
                            child: Hero(
                              tag: 'observation_image_${observation.id}',
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildObservationImage(observation),
                                ),
                              ),
                            ),
                          ),
                          
                        const SizedBox(height: 24),
                        
                        // Nombre científico y común
                        Text(
                          observation.scientificName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        
                        if (observation.commonName != null && observation.commonName!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              observation.commonName!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Tarjeta de información
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.calendar_today,
                                'observation_date'.tr,
                                DateFormat('dd MMMM yyyy').format(observation.observationDate),
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                Icons.location_on,
                                'location'.tr,
                                '${observation.latitude.toStringAsFixed(6)}, ${observation.longitude.toStringAsFixed(6)}',
                              ),
                            ],
                          ),
                        ),
                        
                        // Descripción
                        if (observation.description != null && observation.description!.isNotEmpty) ...[                                
                          const SizedBox(height: 24),
                          Text(
                            'description'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            observation.description!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                        
                        // Galería de fotos
                        if (observation.photos.length > 1) ...[                                
                          const SizedBox(height: 24),
                          Text(
                            'photos_gallery'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPhotoGallery(observation),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        // Botones de acción
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: Text('edit'.tr),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Implementar edición
                                  Get.toNamed('/edit-observation/${observation.id}');
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: Text('delete'.tr),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _confirmDelete(context, observation);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildPhotoGallery(Observation observation) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: observation.photos.length,
        itemBuilder: (context, index) {
          final photo = observation.photos[index];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            width: 120,
            child: Stack(
              children: [
                // Imagen
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => _showFullScreenImage(context, photo.photoUrl),
                    child: Hero(
                      tag: 'gallery_photo_${photo.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SignedImage(
                            imageUrl: photo.photoUrl,
                            fit: BoxFit.cover,
                            placeholder: Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                            errorWidget: Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Número de foto
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${index + 1}/${observation.photos.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Descripción si existe
                if (photo.description != null && photo.description!.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        photo.description!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
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
      barrierColor: Colors.black,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Implementar compartir imagen
                    Get.snackbar(
                      'info'.tr,
                      'share_not_implemented'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                ),
              ],
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Imagen con URL firmada
                Center(
                  child: InteractiveViewer(
                    panEnabled: true,
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: GestureDetector(
                      onDoubleTap: () => Navigator.pop(context),
                      child: SignedImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(color: Colors.white),
                              const SizedBox(height: 16),
                              Text(
                                'loading_image'.tr,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        errorWidget: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'error_loading_image'.tr,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: Text('retry'.tr),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showFullScreenImage(context, imageUrl);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Instrucciones
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'pinch_to_zoom'.tr,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                final success = await Get.find<ObservationController>().deleteObservation(observation.id);
                
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
