import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insectos_app/routes/app_routes.dart';
import 'package:insectos_app/widgets/base_screen.dart';
import 'package:insectos_app/widgets/primary_button.dart';

class ObservationSuccessScreen extends StatelessWidget {
  const ObservationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'observation_success_title'.tr,
      showDrawer: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _buildBody(),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícono de éxito
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 24),
          // Mensaje de éxito
          Text(
            'observation_success_message'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'observation_success_description'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón para crear otra observación
          PrimaryButton(
            text: 'create_another_observation'.tr,
            onPressed: () => Get.offNamed(AppRoutes.createObservation),
            backgroundColor: Colors.green,
          ),
          const SizedBox(height: 12),
          // Botón para ver mis observaciones
          PrimaryButton(
            text: 'view_my_observations'.tr,
            onPressed: () => Get.offNamed(AppRoutes.myObservations),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
