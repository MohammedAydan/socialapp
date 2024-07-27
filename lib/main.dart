// DEV: Mohammed Aydan
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialapp/common/app_routes.dart';
import 'package:socialapp/common/strings.dart';
import 'package:socialapp/core/themes/dark_theme.dart';
import 'package:socialapp/core/themes/light_theme.dart';
import 'package:socialapp/core/translations/translations.dart';
import 'package:socialapp/di/di.dart' as di;
import 'package:socialapp/features/auth/pages/splash_screen.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:socialapp/local.notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  OneSignal.Debug.setLogLevel(OSLogLevel.none);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.initialize(ONESIGNAL_KEY);
  OneSignal.Notifications.requestPermission(true);
  OneSignal.LiveActivities.setupDefault();

  await GetStorage.init();
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_KEY,
  );
  initNotification();

  await di.init();

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends GetView<SettingsController> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "SOCIAL",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: controller.isDarkMode() != null
          ? controller.isDarkMode() == true
              ? ThemeMode.dark
              : ThemeMode.light
          : ThemeMode.system,
      locale: Locale(controller.getLang() ?? "en"),
      translations: CustomTranslations(),
      initialRoute: SplashScreen.routeName,
      getPages: getPages,
    );
  }
}
