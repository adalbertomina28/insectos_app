import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/identification_service.dart';
import '../models/identification_result.dart';

class IdentificationController extends GetxController {
  final IdentificationService _identificationService = IdentificationService();
  final ImagePicker _picker = ImagePicker();
  
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<IdentificationResult?> identificationResult = Rx<IdentificationResult?>(null);
  final RxBool useLocation = false.obs; // Desactivado por defecto
  final Rx<double?> latitude = Rx<double?>(null);
  final Rx<double?> longitude = Rx<double?>(null);
  
  // Método para tomar una foto con la cámara
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      
      if (image != null) {
        final File imageFile = File(image.path);
        // Verificar que el archivo existe y tiene tamaño
        if (await imageFile.exists()) {
          final fileSize = await imageFile.length();


          
          if (fileSize > 0) {
            selectedImage.value = imageFile;
            // Restablecer resultados anteriores
            identificationResult.value = null;
          } else {
            Get.snackbar(
              'Error',
              'El archivo de imagen no es válido',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {

          Get.snackbar(
            'Error',
            'No se encontró el archivo de imagen',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {

      Get.snackbar(
        'Error',
        'Error al capturar la foto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Método para seleccionar una imagen de la galería
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      
      if (image != null) {
        final File imageFile = File(image.path);
        // Verificar que el archivo existe y tiene tamaño
        if (await imageFile.exists()) {
          final fileSize = await imageFile.length();


          
          if (fileSize > 0) {
            selectedImage.value = imageFile;
            // Restablecer resultados anteriores
            identificationResult.value = null;
          } else {
            Get.snackbar(
              'Error',
              'El archivo de imagen no es válido',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {

          Get.snackbar(
            'Error',
            'No se encontró el archivo de imagen',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {

      Get.snackbar(
        'Error',
        'Error al seleccionar la imagen: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Método para obtener la ubicación actual (versión simplificada sin geolocalización)
  Future<void> getCurrentLocation() async {
    // Desactivamos temporalmente la funcionalidad de geolocalización
    useLocation.value = false;
    
    // Informamos al usuario que la geolocalización está temporalmente deshabilitada
    Get.snackbar(
      'info'.tr,
      'La geolocalización está temporalmente deshabilitada',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  // Método para identificar el insecto en la imagen
  Future<void> identifyInsect() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'error'.tr,
        'select_image_first'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    // Verificar que el archivo existe y tiene tamaño
    if (!await selectedImage.value!.exists()) {
      Get.snackbar(
        'Error',
        'El archivo de imagen ya no existe',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    final fileSize = await selectedImage.value!.length();
    if (fileSize <= 0) {
      Get.snackbar(
        'Error',
        'El archivo de imagen está vacío',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    
    try {


      
      // Enviar la imagen para identificación
      final result = await _identificationService.identifyInsect(
        imageFile: selectedImage.value!,
        latitude: useLocation.value ? latitude.value : null,
        longitude: useLocation.value ? longitude.value : null,
      );
      
      identificationResult.value = result;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      Get.snackbar(
        'error'.tr,
        'error_identifying_insect'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Método para ver detalles de un insecto identificado
  void viewInsectDetails(int taxonId) {
    Get.toNamed('/insect-details/$taxonId');
  }
  
  // Método para limpiar la imagen y resultados
  void clearImage() {
    selectedImage.value = null;
    identificationResult.value = null;
    hasError.value = false;
    errorMessage.value = '';
  }
  
  // Método para alternar el uso de ubicación
  void toggleUseLocation() {
    useLocation.value = !useLocation.value;
    if (useLocation.value) {
      getCurrentLocation();
    }
  }
}
