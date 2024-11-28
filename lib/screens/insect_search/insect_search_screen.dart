import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/insect_controller.dart';
import '../../models/insect_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/base_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'insect_detail_screen.dart';

class InsectSearchScreen extends StatelessWidget {
  InsectSearchScreen({super.key});

  final InsectController controller = Get.find<InsectController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'search_screen_title'.tr,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  controller.searchInsects(query);
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('loading'.tr, style: const TextStyle(color: Colors.white)),
                  ],
                ));
              }

              if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Text(
                    'error_loading'.tr,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Text(
                    'no_results'.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.searchResults.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final insect = controller.searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: AppTheme.calPolyGreen,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => InsectDetailScreen(insect: insect));
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: insect.defaultPhoto ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.bug_report),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    insect.preferredCommonName ?? insect.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (insect.scientificName != null)
                                    Text(
                                      insect.scientificName!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  if (insect.observationsCount != null)
                                    Text(
                                      '${insect.observationsCount} observaciones',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
