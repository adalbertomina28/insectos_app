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

class InsectMapScreen extends StatefulWidget {
  const InsectMapScreen({Key? key}) : super(key: key);

  @override
  State<InsectMapScreen> createState() => _InsectMapScreenState();
}

class _InsectMapScreenState extends State<InsectMapScreen> {
  final InsectController _insectController = Get.find<InsectController>();
  final MapController _mapController = MapController();
  
  // Ubicación seleccionada (inicialmente Panamá)
  final RxDouble _latitude = 8.9824.obs;
  final RxDouble _longitude = (-79.5199).obs;
  
  // Radio de búsqueda en km
  final RxInt _searchRadius = 50.obs;
  
  // Marcador para la ubicación seleccionada
  final RxBool _markerPlaced = false.obs;
  
  // Controlador para el panel deslizable
  final DraggableScrollableController _dragController = DraggableScrollableController();
  
  // Estado de expansión del panel
  final RxDouble _sheetExtent = 0.25.obs; // Valor inicial (25% de la pantalla)

  @override
  Widget build(BuildContext context) {
    // Usar el BaseScreen para mantener la consistencia con el resto de la aplicación
    return BaseScreen(
      title: 'mapa_insectos',
      // Añadir solo el botón de actualizar a las acciones
      // El selector de idiomas se añade automáticamente por el BaseScreen
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
    _searchInsectsAtLocation();
  }

  Future<void> _searchInsectsAtLocation() async {
    if (_markerPlaced.value) {
      await _insectController.getNearbyInsects(
        latitude: _latitude.value,
        longitude: _longitude.value,
        radius: _searchRadius.value,
      );
    }
  }

  Widget _buildInsectsList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.25, // Inicialmente ocupa 25% de la pantalla
      minChildSize: 0.15, // Mínimo 15% de la pantalla (aumentado para evitar desbordamiento)
      maxChildSize: 0.8, // Máximo 80% de la pantalla
      controller: _dragController,
      snap: true, // Permite que el panel se ajuste a posiciones específicas
      snapSizes: const [0.15, 0.25, 0.5, 0.8], // Posiciones de ajuste actualizadas
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determinar si estamos en modo compacto (panel pequeño)
              final isCompactMode = constraints.maxHeight < 150;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Importante para evitar desbordamiento
                children: [
                  // Cabecera interactiva con barra de arrastre
                  GestureDetector(
                    // Manejar el arrastre vertical
                    onVerticalDragUpdate: (details) {
                      // Calcular el nuevo tamaño basado en el movimiento del dedo
                      // El movimiento hacia arriba (negativo) aumenta el tamaño
                      // El movimiento hacia abajo (positivo) disminuye el tamaño
                      final newSize = _dragController.size - (details.delta.dy / MediaQuery.of(context).size.height);
                      
                      // Asegurar que el tamaño esté dentro de los límites
                      final clampedSize = newSize.clamp(0.15, 0.8);
                      
                      // Actualizar el tamaño del panel
                      _dragController.jumpTo(clampedSize);
                    },
                    onVerticalDragEnd: (details) {
                      // Velocidad negativa significa arrastre hacia arriba
                      final velocity = details.velocity.pixelsPerSecond.dy;
                      
                      // Determinar a qué tamaño animar basado en la velocidad y posición actual
                      double targetSize;
                      final currentSize = _dragController.size;
                      
                      // Si hay un movimiento rápido, responder a la dirección
                      if (velocity.abs() > 500) {
                        if (velocity < 0) {
                          // Movimiento rápido hacia arriba - expandir
                          targetSize = currentSize < 0.5 ? 0.5 : 0.8;
                        } else {
                          // Movimiento rápido hacia abajo - contraer
                          targetSize = currentSize > 0.25 ? 0.25 : 0.15;
                        }
                      } else {
                        // Movimiento lento - ajustar al tamaño más cercano
                        if (currentSize < 0.2) targetSize = 0.15;
                        else if (currentSize < 0.375) targetSize = 0.25;
                        else if (currentSize < 0.65) targetSize = 0.5;
                        else targetSize = 0.8;
                      }
                      
                      // Animar al tamaño objetivo
                      _dragController.animateTo(
                        targetSize,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Alternar entre expandido y minimizado
                          final currentSize = _dragController.size;
                          if (currentSize < 0.3) {
                            // Si está minimizado, expandir al 50%
                            _dragController.animateTo(
                              0.5,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Si está expandido, minimizar al 15%
                            _dragController.animateTo(
                              0.15,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: Column(
                            children: [
                              // Barra de arrastre visual
                              Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Solo mostrar el texto si no estamos en modo compacto
                              if (!isCompactMode) ...[  
                                const SizedBox(height: 8),
                                // Texto indicativo
                                Text(
                                  'desliza_ver_mas'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Fila de título y botones - adaptable al modo compacto
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0, 
                      vertical: isCompactMode ? 4.0 : 8.0, // Reducir el padding vertical en modo compacto
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Título con contador de insectos
                        Expanded(
                          child: Obx(() => Text(
                                'insectos_encontrados'.tr +
                                    ': ${_insectController.nearbyInsects.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCompactMode ? 14 : 16, // Texto más pequeño en modo compacto
                                  overflow: TextOverflow.ellipsis, // Evitar desbordamiento de texto
                                ),
                              )),
                        ),
                        // Botones de control
                        Row(
                          mainAxisSize: MainAxisSize.min, // Ocupar solo el espacio necesario
                          children: [
                            // Botón para expandir el panel
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_up),
                              padding: EdgeInsets.all(isCompactMode ? 4.0 : 8.0), // Reducir padding en modo compacto
                              constraints: const BoxConstraints(), // Eliminar restricciones mínimas
                              onPressed: () {
                                _dragController.animateTo(
                                  0.5, // Expandir al 50%
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              tooltip: 'expandir_panel'.tr,
                            ),
                            // Botón para minimizar el panel
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              padding: EdgeInsets.all(isCompactMode ? 4.0 : 8.0), // Reducir padding en modo compacto
                              constraints: const BoxConstraints(), // Eliminar restricciones mínimas
                              onPressed: () {
                                _dragController.animateTo(
                                  0.15, // Minimizar al 15%
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              tooltip: 'minimizar_panel'.tr,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Divisor más delgado en modo compacto
                  Divider(height: isCompactMode ? 0.5 : 1, thickness: isCompactMode ? 0.5 : 1),
                  // Lista de insectos
                  Expanded(
                    child: Obx(() {
                      if (_insectController.error.isNotEmpty) {
                        return Center(
                          child: Text(
                            _insectController.error.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isCompactMode ? 12 : 14, // Texto más pequeño en modo compacto
                            ),
                          ),
                        );
                      }
                      
                      if (_insectController.nearbyInsects.isEmpty) {
                        return Center(
                          child: Text(
                            'no_insectos_encontrados'.tr,
                            style: TextStyle(
                              fontSize: isCompactMode ? 12 : 14, // Texto más pequeño en modo compacto
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        controller: scrollController, // Importante: usar el scrollController proporcionado
                        padding: EdgeInsets.zero, // Eliminar padding por defecto
                        itemCount: _insectController.nearbyInsects.length,
                        itemBuilder: (context, index) {
                          final insect = _insectController.nearbyInsects[index];
                          return isCompactMode 
                              ? _buildCompactInsectListItem(insect) // Versión compacta del item
                              : _buildInsectListItem(insect); // Versión normal del item
                        },
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
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
