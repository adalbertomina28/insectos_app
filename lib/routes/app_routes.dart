import 'package:get/get.dart';

import '../screens/encyclopedia/encyclopedia_screen.dart';
import '../screens/rna/rna_screen.dart';
import '../screens/insect_search/insect_search_screen.dart';
import '../screens/key_insects/key_insects_screen.dart';
import '../screens/resources/resources_screen.dart';
import '../screens/about/about_screen.dart';

class AppRoutes {
  static const String encyclopedia = '/encyclopedia';
  static const String rna = '/rna';
  static const String insectSearch = '/insect-search';
  static const String keyInsects = '/key-insects';
  static const String resources = '/resources';
  static const String about = '/about';

  static List<GetPage> pages = [
    GetPage(
      name: encyclopedia,
      page: () => EncyclopediaScreen(),
    ),
    GetPage(
      name: rna,
      page: () => const RNAScreen(),
    ),
    GetPage(
      name: insectSearch,
      page: () => const InsectSearchScreen(),
    ),
    GetPage(
      name: keyInsects,
      page: () => KeyInsectsScreen(),
    ),
    GetPage(
      name: resources,
      page: () => ResourcesScreen(),
    ),
    GetPage(
      name: about,
      page: () => const AboutScreen(),
    ),
  ];
}
