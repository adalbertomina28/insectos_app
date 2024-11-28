import 'package:get/get.dart';
import 'en.dart';
import 'es.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'es': es,
  };
}
