import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:insectos_app/controllers/observation_controller.dart';

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
  final List<File> _selectedImages = [];
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
    );

    if (picked != null && picked != _controller.selectedDate.value) {
      _controller.selectedDate.value = picked;
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        for (var image in images) {
          _selectedImages.add(File(image.path));
        }
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _selectedImages.add(File(photo.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<List<String>> _uploadImages() async {
    // Aquí iría la lógica para subir las imágenes a Supabase o al servidor
    // Por ahora, simularemos URLs de imágenes
    List<String> urls = [];
    for (var i = 0; i < _selectedImages.length; i++) {
      urls.add('https://example.com/image_$i.jpg');
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

      // Mostrar diálogo de carga
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      try {
        // Subir imágenes primero
        final List<String> photoUrls = await _uploadImages();

        // Crear la observación
        final success = await _controller.createObservation(
          commonName: _commonNameController.text,
          observationDate: _controller.selectedDate.value,
          latitude: _controller.latitude.value,
          longitude: _controller.longitude.value,
          conditionId: _controller.conditionId.value,
          stateId: _controller.stateId.value,
          stageId: _controller.stageId.value,
          sexId: _controller.sexId.value,
          description: _descriptionController.text,
          photoUrls: photoUrls,
        );

        // Cerrar diálogo de carga
        Get.back();

        if (success) {
          // Mostrar mensaje de éxito
          Get.snackbar(
            'exito'.tr,
            'observacion_creada'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navegar de vuelta a la pantalla anterior
          Get.back();
        } else {
          // Mostrar mensaje de error
          Get.snackbar(
            'error'.tr,
            'error_crear_observacion'.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
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
            icon: const Icon(Icons.save),
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
                    border: const OutlineInputBorder(),
                    hintText: 'escriba_para_buscar'.tr,
                    suffixIcon: Obx(() => _controller.isSearching.value
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Icon(Icons.search)),
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
                        Text('nombre_cientifico'.tr + ':',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(_controller.scientificName.value,
                            style:
                                const TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 4),
                        Text(
                            'ID iNaturalist: ${_controller.inaturalistId.value}'),
                      ],
                    ),
                  );
                }),

                // Fecha de observación
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'fecha_observacion'.tr,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
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
                    TextButton(
                      onPressed: () {
                        // Aquí se podría implementar la obtención de la ubicación actual
                      },
                      child: Text('mi_ubicacion'.tr),
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
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
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
                    ),
                    ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: Text('camara'.tr),
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
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(_selectedImages[index]),
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
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
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
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('guardar_observacion'.tr),
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
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'campo_requerido'.tr;
        }
        return null;
      },
    );
  }
}
