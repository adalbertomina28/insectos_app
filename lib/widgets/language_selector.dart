import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Color.fromRGBO(67, 160, 71, 1)),
      onSelected: (String langCode) {
        LanguageController.to.changeLanguage(langCode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'es',
          child: Row(
            children: [
              Obx(() => Radio<String>(
                    value: 'es',
                    groupValue: LanguageController.to.currentLanguage.value,
                    onChanged: (_) => LanguageController.to.changeLanguage('es'),
                    fillColor: WidgetStateProperty.all(Colors.white),
                  )),
              Text(
                'spanish'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Obx(() => Radio<String>(
                    value: 'en',
                    groupValue: LanguageController.to.currentLanguage.value,
                    onChanged: (_) => LanguageController.to.changeLanguage('en'),
                    fillColor: WidgetStateProperty.all(Colors.white),
                  )),
              Text(
                'english'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      color: Theme.of(context).primaryColor, // Color de fondo del menú
    );
  }
}
