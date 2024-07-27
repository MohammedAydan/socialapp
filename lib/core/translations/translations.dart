import 'package:get/get.dart';
import 'package:socialapp/core/translations/ar.dart';
import 'package:socialapp/core/translations/en.dart';

class CustomTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en": en,
        "ar": ar,
      };
}
