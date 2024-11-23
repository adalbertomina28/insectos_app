import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/insect_model.dart';
import '../../services/inaturalist_service.dart';
import '../../theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'insect_detail_screen.dart';

class InsectSearchScreen extends StatefulWidget {
  const InsectSearchScreen({super.key});

  @override
  State<InsectSearchScreen> createState() => _InsectSearchScreenState();
}

class _InsectSearchScreenState extends State<InsectSearchScreen> {
  final INaturalistService _service = INaturalistService();
  final TextEditingController _searchController = TextEditingController();
  List<Insect> _insects = [];
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchInsects(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final result = await _service.searchInsects(query: query);
      final List<dynamic> results = result['results'] as List<dynamic>;

      setState(() {
        _insects = results.map((json) => Insect.fromJson(json)).toList();
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: AppTheme.calPolyGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _hasSearched
                ? '¡Ups! No encontramos insectos'
                : '¡Explora el mundo de los insectos!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.calPolyGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasSearched
                ? 'Intenta con otro término de búsqueda'
                : 'Busca por nombre común o científico',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsectImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.calPolyGreen.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bug_report,
                size: 48,
                color: AppTheme.calPolyGreen.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Imagen no disponible',
                style: TextStyle(
                  color: AppTheme.calPolyGreen.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 200,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppTheme.calPolyGreen.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sin imagen',
                  style: TextStyle(
                    color: AppTheme.calPolyGreen.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda de Insectos'),
        backgroundColor: AppTheme.calPolyGreen,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar insectos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _insects = [];
                            _hasSearched = false;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: _searchInsects,
              onChanged: (value) {
                setState(() {}); // Para actualizar el botón de limpiar
              },
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Expanded(
              child: Center(
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
                      'Ocurrió un error',
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
              ),
            )
          else if (_insects.isEmpty)
            Expanded(child: _buildEmptyState())
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _insects.length,
                itemBuilder: (context, index) {
                  final insect = _insects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () => Get.to(() => InsectDetailScreen(insect: insect)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInsectImage(insect.defaultPhoto),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (insect.preferredCommonName !=
                                              null)
                                            Text(
                                              insect.preferredCommonName!,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.calPolyGreen,
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            insect.scientificName ??
                                                insect.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (insect.wikipediaUrl != null)
                                      Tooltip(
                                        message: 'Ver en Wikipedia',
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.open_in_new,
                                            color: AppTheme.calPolyGreen,
                                          ),
                                          onPressed: () =>
                                              _launchUrl(insect.wikipediaUrl),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Información taxonómica
                                if (insect.rank != null ||
                                    insect.ancestorTaxa != null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.calPolyGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (insect.rank != null)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.category,
                                                size: 16,
                                                color: AppTheme.calPolyGreen,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Rango: ${insect.rank![0].toUpperCase()}${insect.rank!.substring(1)}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.calPolyGreen,
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (insect.rank != null &&
                                            insect.ancestorTaxa != null)
                                          const SizedBox(height: 8),
                                        if (insect.ancestorTaxa != null)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.account_tree,
                                                size: 16,
                                                color: AppTheme.calPolyGreen,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  insect.ancestorTaxa!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        AppTheme.calPolyGreen,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                // Estadísticas
                                if (insect.observationsCount != null)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.visibility,
                                        size: 16,
                                        color: AppTheme.calPolyGreen,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        NumberFormat.compact()
                                            .format(insect.observationsCount),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.calPolyGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'observaciones',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
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
                },
              ),
            ),
        ],
      ),
    );
  }
}
