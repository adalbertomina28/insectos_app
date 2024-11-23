import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/insect_model.dart';
import '../../services/inaturalist_service.dart';
import '../../theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class InsectDetailScreen extends StatefulWidget {
  final Insect insect;

  const InsectDetailScreen({
    super.key,
    required this.insect,
  });

  @override
  State<InsectDetailScreen> createState() => _InsectDetailScreenState();
}

class _InsectDetailScreenState extends State<InsectDetailScreen> {
  final INaturalistService _service = INaturalistService();
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _details;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await _service.getInsectDetails(widget.insect.id);
      setState(() {
        _details = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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

  Widget _buildDetailSection({
    required String title,
    required Widget content,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Insecto'),
        backgroundColor: AppTheme.calPolyGreen,
        actions: [
          if (widget.insect.wikipediaUrl != null)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _launchUrl(widget.insect.wikipediaUrl),
              tooltip: 'Ver en Wikipedia',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar detalles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[300],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Por favor, intenta de nuevo más tarde',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen principal
                      if (widget.insect.defaultPhoto != null)
                        CachedNetworkImage(
                          imageUrl: widget.insect.defaultPhoto!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.calPolyGreen.withOpacity(0.1),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.calPolyGreen.withOpacity(0.1),
                            height: 250,
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppTheme.calPolyGreen,
                              ),
                            ),
                          ),
                        ),

                      // Información básica
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.insect.preferredCommonName != null)
                              Text(
                                widget.insect.preferredCommonName!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.calPolyGreen,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              widget.insect.scientificName ?? widget.insect.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Estadísticas
                      if (widget.insect.observationsCount != null)
                        _buildDetailSection(
                          title: 'Estadísticas',
                          content: Row(
                            children: [
                              const Icon(
                                Icons.visibility,
                                size: 20,
                                color: AppTheme.calPolyGreen,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${NumberFormat.compact().format(widget.insect.observationsCount)} observaciones',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.calPolyGreen,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Taxonomía
                      if (widget.insect.ancestorTaxa != null)
                        _buildDetailSection(
                          title: 'Clasificación Taxonómica',
                          content: Text(
                            widget.insect.ancestorTaxa!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                      // Información adicional del API
                      if (_details != null) ...[
                        if (_details!['wikipedia_summary'] != null)
                          _buildDetailSection(
                            title: 'Descripción',
                            content: Text(
                              _details!['wikipedia_summary'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),

                        if (_details!['conservation_status'] != null)
                          _buildDetailSection(
                            title: 'Estado de Conservación',
                            content: Row(
                              children: [
                                Icon(
                                  Icons.eco,
                                  size: 20,
                                  color: _getConservationStatusColor(_details!['conservation_status']['status']),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getConservationStatusText(_details!['conservation_status']['status']),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _getConservationStatusColor(_details!['conservation_status']['status']),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (_details!['wikipedia_url'] != null)
                          _buildDetailSection(
                            title: 'Enlaces',
                            content: InkWell(
                              onTap: () => _launchUrl(_details!['wikipedia_url']),
                              child: Text(
                                'Ver artículo completo en Wikipedia',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.calPolyGreen,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                      ],
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Divider(),
                            SizedBox(height: 8),
                            Text(
                              'Datos proporcionados por iNaturalist',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'www.inaturalist.org',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.calPolyGreen,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Color _getConservationStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'extinct':
        return Colors.black;
      case 'extinct in the wild':
        return Colors.red[900]!;
      case 'critically endangered':
        return Colors.red;
      case 'endangered':
        return Colors.orange;
      case 'vulnerable':
        return Colors.yellow[700]!;
      case 'near threatened':
        return Colors.blue;
      case 'least concern':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getConservationStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'extinct':
        return 'Extinto';
      case 'extinct in the wild':
        return 'Extinto en Estado Silvestre';
      case 'critically endangered':
        return 'En Peligro Crítico';
      case 'endangered':
        return 'En Peligro';
      case 'vulnerable':
        return 'Vulnerable';
      case 'near threatened':
        return 'Casi Amenazado';
      case 'least concern':
        return 'Preocupación Menor';
      default:
        return 'Desconocido';
    }
  }
}
