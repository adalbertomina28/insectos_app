import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as Math;
import '../../controllers/insect_controller.dart';
import '../../models/insect_model.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/base_screen.dart';
import '../../widgets/insect_draggable_panel.dart';

class InsectMapScreen extends StatefulWidget {
  const InsectMapScreen({Key? key}) : super(key: key);

  @override
  State<InsectMapScreen> createState() => _InsectMapScreenState();
}

class _InsectMapScreenState extends State<InsectMapScreen> {
  final InsectController _insectController = Get.find<InsectController>();
  final MapController _mapController = MapController();
  
  // Controlador para el panel de insectos
  InsectPanelController? _panelController;
  
  // Ubicación seleccionada (inicialmente Panamá)
  final RxDouble _latitude = 8.9824.obs;
  final RxDouble _longitude = (-79.5199).obs;
  
  // Radio de búsqueda en km
  final RxInt _searchRadius = 50.obs;
  
  // Marcador para la ubicación seleccionada
  final RxBool _markerPlaced = false.obs;
  
  // Controlar si el panel debe expandirse automáticamente
  final RxBool _autoExpandPanel = true.obs;
  


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usar el BaseScreen para mantener la consistencia con el resto de la aplicación
    return BaseScreen(
      title: 'mapa_insectos',
      // Ocultar el selector de idioma en esta pantalla para evitar problemas
      showLanguageSelector: false,
      // Añadir solo el botón de actualizar a las acciones
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.green),
          onPressed: _searchInsectsAtLocation,
          tooltip: 'buscar_insectos'.tr,
        ),
      ],
      child: Column(
        children: [
          _buildRadiusSelector(),
          Expanded(
            child: Stack(
              children: [
                _buildMap(),
                Obx(() => _insectController.isLoading.value
                    ? const Center(child: LoadingIndicator())
                    : const SizedBox.shrink()),
                _buildInsectsList(), // Colocado al final para que esté por encima de los otros elementos
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text('radio_busqueda'.tr + ': '),
          Obx(() => Text('${_searchRadius.value} km')),
          Expanded(
            child: Obx(
              () => Slider(
                value: _searchRadius.value.toDouble(),
                min: 10,
                max: 100,
                divisions: 9,
                label: '${_searchRadius.value} km',
                onChanged: (value) {
                  _searchRadius.value = value.toInt();
                },
                onChangeEnd: (value) {
                  if (_markerPlaced.value) {
                    _searchInsectsAtLocation();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(_latitude.value, _longitude.value),
        initialZoom: 9.0,
        onTap: _handleMapTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.insectos_app',
          subdomains: const ['a', 'b', 'c'],
          maxZoom: 19,
          tileProvider: CancellableNetworkTileProvider(),
        ),
        Obx(() => _markerPlaced.value
            ? MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(_latitude.value, _longitude.value),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              )
            : const MarkerLayer(markers: [])),
        Obx(() => _buildInsectMarkers()),
      ],
    );
  }

  MarkerLayer _buildInsectMarkers() {
    // Generar semillas diferentes para cada insecto
    final List<int> seeds = List.generate(
      _insectController.nearbyInsects.length,
      (index) => DateTime.now().millisecondsSinceEpoch + index * 1000,
    );

    return MarkerLayer(
      markers: _insectController.nearbyInsects
          .asMap()
          .entries
          .map(
            (entry) {
              final int index = entry.key;
              final Insect insect = entry.value;
              final LatLng position = _getDistributedPoint(
                _latitude.value,
                _longitude.value,
                index,
                seeds[index],
                _insectController.nearbyInsects.length,
              );
              
              return Marker(
                width: 40.0,
                height: 40.0,
                point: position,
                child: GestureDetector(
                  onTap: () => _showInsectDetails(insect),
                  child: Tooltip(
                    message: insect.preferredCommonName ?? insect.name,
                    child: Stack(
                      children: [
                        // Sombra
                        Positioned(
                          left: 2,
                          top: 2,
                          child: Icon(
                            Icons.bug_report,
                            color: Colors.black.withOpacity(0.3),
                            size: 24.0,
                          ),
                        ),
                        // Icono principal
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bug_report,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
          .toList(),
    );
  }

  // Genera puntos distribuidos alrededor de la ubicación seleccionada
  // en un patrón circular para una mejor visualización
  LatLng _getDistributedPoint(double lat, double lng, int index, int seed, int total) {
    // Usar el índice y la semilla para generar un ángulo y una distancia
    final double angle = (index / total) * 2 * 3.14159; // Distribuir en círculo
    final double distance = 0.02 + (seed % 10) / 1000; // Variar la distancia (entre 0.02 y 0.03 grados)
    
    // Calcular el desplazamiento usando trigonometría
    final double deltaLat = distance * Math.cos(angle);
    final double deltaLng = distance * Math.sin(angle);
    
    return LatLng(lat + deltaLat, lng + deltaLng);
  }

  void _handleMapTap(TapPosition tapPosition, LatLng point) {
    _latitude.value = point.latitude;
    _longitude.value = point.longitude;
    _markerPlaced.value = true;
    
    // Asegurarse de que la expansión automática esté activada antes de buscar insectos
    _autoExpandPanel.value = true;
    
    // Buscar insectos en la ubicación seleccionada
    _searchInsectsAtLocation();
  }

  Future<void> _searchInsectsAtLocation() async {
    if (_markerPlaced.value) {
      await _insectController.getNearbyInsects(
        latitude: _latitude.value,
        longitude: _longitude.value,
        radius: _searchRadius.value,
      );
      
      // Si se encontraron insectos y la expansión automática está activada, expandir el panel
      if (_autoExpandPanel.value && _insectController.nearbyInsects.isNotEmpty) {
        // Dar tiempo para que la UI se actualice antes de expandir el panel
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_panelController != null) {
            _panelController!.expandPanel();
          }
        });
      }
    }
  }

  Widget _buildInsectsList() {
    // Usamos un widget independiente para el panel deslizable con expansión automática
    return Obx(() => InsectDraggablePanel(
      key: ValueKey('insect_panel_${_insectController.nearbyInsects.length}'),
      insectController: _insectController,
      buildCompactInsectListItem: _buildCompactInsectListItem,
      buildInsectListItem: _buildInsectListItem,
      showInsectDetails: _showInsectDetails,
      autoExpandOnResults: _autoExpandPanel.value, // Usar la variable reactiva para controlar la expansión automática
      onControllerReady: (controller) {
        // Guardar el controlador cuando esté listo
        _panelController = controller;
      },
    ));
  }
  
  // Versión compacta del elemento de la lista para cuando el panel está minimizado
  Widget _buildCompactInsectListItem(Insect insect) {
    return ListTile(
      dense: true, // Hace que el ListTile sea más compacto
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0), // Padding reducido
      minLeadingWidth: 30, // Ancho mínimo reducido para el leading
      leading: insect.defaultPhoto != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4), // Radio más pequeño
              child: Image.network(
                insect.defaultPhoto!,
                width: 30, // Imagen más pequeña
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey[300],
                    child: const Icon(Icons.bug_report, size: 16),
                  );
                },
              ),
            )
          : Container(
              width: 30,
              height: 30,
              color: Colors.grey[300],
              child: const Icon(Icons.bug_report, size: 16),
            ),
      title: Text(
        insect.preferredCommonName ?? insect.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // Sin subtítulo en la versión compacta para ahorrar espacio
      onTap: () => _showInsectDetails(insect),
    );
  }

  Widget _buildInsectListItem(Insect insect) {
    return ListTile(
      leading: insect.defaultPhoto != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                insect.defaultPhoto!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.bug_report),
                  );
                },
              ),
            )
          : Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: const Icon(Icons.bug_report),
            ),
      title: Text(
        insect.preferredCommonName ?? insect.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        insect.scientificName ?? '',
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
      onTap: () => _showInsectDetails(insect),
    );
  }

  void _showInsectDetails(Insect insect) {
    _insectController.selectedInsect.value = insect;
    Get.toNamed('/insect-details', arguments: insect);
  }
}
