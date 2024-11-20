import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/encyclopedia/encyclopedia_screen.dart';
import 'screens/rna/rna_screen.dart';
import 'screens/key_insects/key_insects_screen.dart';
import 'screens/resources/resources_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/about/about_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const InsectosApp());
}

class InsectosApp extends StatelessWidget {
  const InsectosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Insectos App',
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/encyclopedia', page: () => EncyclopediaScreen()),
        GetPage(name: '/rna', page: () => const RNAScreen()),
        GetPage(name: '/key-insects', page: () => KeyInsectsScreen()),
        GetPage(name: '/resources', page: () => ResourcesScreen()),
        GetPage(name: '/about', page: () => const AboutScreen()),
      ],
    );
  }
}
