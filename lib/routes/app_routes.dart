import 'package:get/get.dart';

import '../screens/encyclopedia/encyclopedia_screen.dart';
import '../screens/nanotech/nanotech_screen.dart';
import '../screens/nanotech/nanotech_detail_screen.dart';
import '../models/nanotech_info.dart';

class AppRoutes {
  static const String encyclopedia = '/encyclopedia';
  static const String nanotech = '/nanotech';
  static const String nanotechDetail = '/nanotech/detail';

  static List<GetPage> pages = [
    GetPage(
      name: encyclopedia,
      page: () => EncyclopediaScreen(),
    ),
    GetPage(
      name: nanotech,
      page: () => NanoTechScreen(),
    ),
    GetPage(
      name: nanotechDetail,
      page: () {
        final NanoTechInfo info = Get.arguments;
        return NanoTechDetailScreen(info: info);
      },
    ),
  ];
}
