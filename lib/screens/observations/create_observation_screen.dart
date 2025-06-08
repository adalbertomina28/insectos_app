import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:insectos_app/controllers/observation_controller.dart';
import 'package:insectos_app/controllers/auth_controller.dart';
import 'package:insectos_app/services/file_upload_service.dart';
import 'package:insectos_app/routes/app_routes.dart';
import 'package:geolocator/geolocator.dart';

class CreateObservationScreen extends StatefulWidget {
  const CreateObservationScreen({super.key});

  @override
  State<CreateObservationScreen> createState() =>
      _CreateObservationScreenState();
}

class _CreateObservationScreenState extends State<CreateObservationScreen> {
  final ObservationController _controller = Get.find<ObservationController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commonNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<dynamic> _selectedImages = []; // Puede contener File o XFile
  final MapController _mapController = MapController();

  // Para la búsqueda de insectos
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.resetObservationForm();

    // Inicializar controladores de texto con valores iniciales
    _dateController.text =
        DateFormat('dd/MM/yyyy').format(_controller.selectedDate.value);

    // Escuchar cambios en la ubicación para centrar el mapa
    _controller.latitude.listen((_) => _centerMap());
    _controller.longitude.listen((_) => _centerMap());

    // Configurar listener para búsqueda de insectos
    _commonNameController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_commonNameController.text.length >= 3) {
        _controller.searchInsects(_commonNameController.text);
      } else {
        _controller.searchResults.clear();
      }
    });
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _centerMap() {
    if (_controller.latitude.value != 0.0 &&
        _controller.longitude.value != 0.0) {
      _mapController.move(
        LatLng(_controller.latitude.value, _controller.longitude.value),
        13.0,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Color del encabezado y fechas seleccionadas
              onPrimary: Colors.white, // Color del texto en el encabezado
              surface: Colors.white, // Color de fondo del calendario
              onSurface: Colors.black, // Color del texto de las fechas
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _controller.selectedDate.value) {
      _controller.selectedDate.value = picked;
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // Método para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    try {
      // Mostrar indicador de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.back(); // Cerrar diálogo de carga
          Get.snackbar(
            'error_ubicacion'.tr,
            'permisos_ubicacion_denegados'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        Get.back(); // Cerrar diálogo de carga
        Get.snackbar(
          'error_ubicacion'.tr,
          'permisos_ubicacion_permanentemente_denegados'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Actualizar los valores en el controlador
      _controller.latitude.value = position.latitude;
      _controller.longitude.value = position.longitude;

      // Actualizar la posición del mapa
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0, // Zoom más cercano para ver mejor la ubicación
      );

      // Cerrar diálogo de carga
      Get.back();

      // Mostrar mensaje de éxito
      Get.snackbar(
        'exito_ubicacion'.tr,
        'ubicacion_actualizada'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Cerrar diálogo de carga
      Get.back();
      
      // Mostrar error
      Get.snackbar(
        'error_ubicacion'.tr,
        'error_obtener_ubicacion'.tr + ': $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null && images.isNotEmpty) {
        // Procesar las imágenes para web
        if (kIsWeb) {
          int index = _selectedImages.length;
          for (var image in images) {
            // Leer los bytes para mostrar la imagen
            final bytes = await image.readAsBytes();
            setState(() {
              _selectedImages.add(image);
              _webImageBytes[index] = bytes;
              index++;
            });
          }
        } else {
          // Para móvil es más simple
          setState(() {
            for (var image in images) {
              _selectedImages.add(File(image.path));
            }
          });
        }
      }
    } catch (e) {
      print('Error al seleccionar imágenes: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar las imágenes',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        if (kIsWeb) {
          // Para web, necesitamos leer los bytes
          final bytes = await photo.readAsBytes();
          setState(() {
            int index = _selectedImages.length;
            _selectedImages.add(photo);
            _webImageBytes[index] = bytes;
          });
        } else {
          // Para móvil es más simple
          setState(() {
            _selectedImages.add(File(photo.path));
          });
        }
      }
    } catch (e) {
      print('Error al tomar foto: $e');
      Get.snackbar(
        'Error',
        'No se pudo tomar la foto',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  ImageProvider _getImageProvider(int index) {
    final imageFile = _selectedImages[index];

    if (kIsWeb) {
      // En web, usamos MemoryImage con los bytes almacenados
      if (_webImageBytes.containsKey(index)) {
        return MemoryImage(_webImageBytes[index]!);
      }
    } else {
      // Para móvil
      if (imageFile is XFile) {
        return FileImage(File(imageFile.path));
      } else if (imageFile is File) {
        return FileImage(imageFile);
      }
    }

    // Fallback por si acaso
    return const AssetImage('assets/images/placeholder.png');
  }

  // Mapa para almacenar los bytes de las imágenes web
  final Map<int, Uint8List> _webImageBytes = {};

  Future<List<String>> _uploadImages() async {
    final fileUploadService = FileUploadService();
    final List<String> urls = [];
    // Obtener el ID del usuario actual desde el controlador de autenticación
    final authController = Get.find<AuthController>();
    final String userId =
        authController.currentUser.value?.id ?? 'user_id_here';

    try {
      for (var imageFile in _selectedImages) {
        String? imageUrl;

        if (kIsWeb) {
          // Para web, convertir XFile a Map con bytes
          if (imageFile is XFile) {
            final bytes = await imageFile.readAsBytes();
            final fileData = {
              'bytes': bytes,
              'name': imageFile.name,
            };
            imageUrl = await fileUploadService.uploadImage(fileData, userId);
          } else {
            print(
                'Tipo de archivo no soportado en web: ${imageFile.runtimeType}');
            continue;
          }
        } else {
          // Para móvil, asegurar que sea un File
          if (imageFile is File) {
            imageUrl = await fileUploadService.uploadImage(imageFile, userId);
          } else if (imageFile is XFile) {
            // Si por alguna razón tenemos XFile en móvil
            final file = File(imageFile.path);
            imageUrl = await fileUploadService.uploadImage(file, userId);
          } else {
            print(
                'Tipo de archivo no soportado en móvil: ${imageFile.runtimeType}');
            continue;
          }
        }

        if (imageUrl != null) {
          urls.add(imageUrl);
        }
      }
    } catch (e) {
      print('Error al subir imágenes: $e');
      Get.snackbar(
        'Error',
        'No se pudieron subir las imágenes',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    return urls;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Verificar si se ha seleccionado un insecto
      if (!_controller.hasSelectedInsect.value) {
        Get.snackbar(
          'error'.tr,
          'Debes seleccionar un insecto de la lista de resultados',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Verificar que se hayan seleccionado imágenes
      if (_selectedImages.isEmpty) {
        Get.snackbar(
          'error'.tr,
          'Debes añadir al menos una imagen',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Mostrar diálogo de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      try {
        // Subir las imágenes primero
        final List<String> imageUrls = await _uploadImages();

        if (imageUrls.isEmpty) {
          throw Exception('No se pudieron subir las imágenes');
        }

        // Crear la observación con las URLs de las imágenes
        await _controller.createObservation(
          scientificName: _controller.scientificName.value,
          commonName: _commonNameController.text,
          inaturalistId: _controller.inaturalistId.value,
          observationDate: _controller.selectedDate.value,
          latitude: _controller.latitude.value,
          longitude: _controller.longitude.value,
          conditionId: _controller.conditionId.value,
          stateId: _controller.stateId.value,
          stageId: _controller.stageId.value,
          sexId: _controller.sexId.value,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          imageUrls: imageUrls, // Usar URLs en lugar de archivos
        );

        // Cerrar diálogo de carga
        Get.back();

        // Navegar a la pantalla de éxito
        Get.offAllNamed(AppRoutes.observationSuccess);
      } catch (e) {
        // Cerrar diálogo de carga
        Get.back();

        // Mostrar mensaje de error
        Get.snackbar(
          'error'.tr,
          'error_crear_observacion'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        print('Error en _submitForm: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crear_observacion'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.blue[700]),
            onPressed: _submitForm,
            tooltip: 'guardar'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.loadingCatalogs.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de información básica
                _buildSectionTitle('informacion_basica'.tr),

                // Nombre común con búsqueda
                TextFormField(
                  controller: _commonNameController,
                  decoration: InputDecoration(
                    labelText: 'nombre_comun'.tr,
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    hintText: 'escriba_para_buscar'.tr,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue[700]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: Obx(() => _controller.isSearching.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[700]!),
                            ),
                          )
                        : Icon(Icons.search, color: Colors.blue[700])),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'campo_requerido'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Resultados de búsqueda
                Obx(() {
                  if (_controller.searchResults.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final insect = _controller.searchResults[index];
                        return ListTile(
                          title:
                              Text(insect['common_name'] ?? 'Sin nombre común'),
                          subtitle: Text(insect['scientific_name'] ?? ''),
                          onTap: () {
                            _controller.selectInsect(insect);
                            _commonNameController.text =
                                insect['common_name'] ?? '';
                            // Ocultar el teclado
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 8),

                // Mostrar el nombre científico si se ha seleccionado un insecto
                Obx(() {
                  if (!_controller.hasSelectedInsect.value) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${'nombre_cientifico'.tr}:',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(_controller.scientificName.value,
                            style:
                                const TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 4)
                      ],
                    ),
                  );
                }),

                // Fecha de observación
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'fecha_observacion'.tr,
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue[700]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.blue[700]),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'campo_requerido'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Sección de ubicación
                _buildSectionTitle('ubicacion'.tr),

                // Mapa para seleccionar ubicación
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: LatLng(9.9281, -84.0907), // Costa Rica
                        initialZoom: 7.0,
                        onTap: (tapPosition, point) {
                          _controller.latitude.value = point.latitude;
                          _controller.longitude.value = point.longitude;
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: LatLng(_controller.latitude.value,
                                  _controller.longitude.value),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() => Text(
                            'Lat: ${_controller.latitude.value.toStringAsFixed(6)}, Lng: ${_controller.longitude.value.toStringAsFixed(6)}',
                            style: const TextStyle(fontSize: 12),
                          )),
                    ),
                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: Icon(Icons.my_location,
                          size: 18, color: Colors.blue[700]),
                      label: Text('mi_ubicacion'.tr,
                          style: TextStyle(color: Colors.blue[700])),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sección de características
                _buildSectionTitle('caracteristicas'.tr),

                // Condición
                _buildDropdown(
                  label: 'condicion'.tr,
                  items: _controller.conditions.map((condition) {
                    return DropdownMenuItem<int>(
                      value: condition['id'],
                      child: Text(condition['name']),
                    );
                  }).toList(),
                  value: _controller.conditionId.value,
                  onChanged: (value) {
                    if (value != null) {
                      _controller.conditionId.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Estado
                _buildDropdown(
                  label: 'estado'.tr,
                  items: _controller.states.map((state) {
                    return DropdownMenuItem<int>(
                      value: state['id'],
                      child: Text(state['name']),
                    );
                  }).toList(),
                  value: _controller.stateId.value,
                  onChanged: (value) {
                    if (value != null) {
                      _controller.stateId.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Etapa
                _buildDropdown(
                  label: 'etapa'.tr,
                  items: _controller.stages.map((stage) {
                    return DropdownMenuItem<int>(
                      value: stage['id'],
                      child: Text(stage['name']),
                    );
                  }).toList(),
                  value: _controller.stageId.value,
                  onChanged: (value) {
                    if (value != null) {
                      _controller.stageId.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Sexo
                _buildDropdown(
                  label: 'sexo'.tr,
                  items: _controller.sexes.map((sex) {
                    return DropdownMenuItem<int>(
                      value: sex['id'],
                      child: Text(sex['name']),
                    );
                  }).toList(),
                  value: _controller.sexId.value,
                  onChanged: (value) {
                    if (value != null) {
                      _controller.sexId.value = value;
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Sección de descripción
                _buildSectionTitle('descripcion'.tr),

                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'descripcion_opcional'.tr,
                    labelStyle: TextStyle(color: Colors.blue[700]),
                    filled: true,
                    fillColor: Colors.transparent,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue[700]!, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    alignLabelWithHint: true,
                  ),
                  style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // Sección de fotos
                _buildSectionTitle('fotos'.tr),

                // Botones para seleccionar imágenes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: Text('galeria'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blue[700],
                        elevation: 0,
                        side: BorderSide(color: Colors.blue[700]!),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: Text('camara'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blue[700],
                        elevation: 0,
                        side: BorderSide(color: Colors.blue[700]!),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Previsualización de imágenes seleccionadas
                if (_selectedImages.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green[200]!),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: _getImageProvider(index),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.red[400]!, width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red[700],
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 32),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: Text('guardar_observacion'.tr,
                        style: const TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<DropdownMenuItem<int>> items,
    required int value,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[700]!, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      icon: Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
      dropdownColor: Colors.white,
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
      validator: (value) {
        if (value == null) {
          return 'campo_requerido'.tr;
        }
        return null;
      },
    );
  }
}
