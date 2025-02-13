import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';
import 'package:socialapp/widgets/bottom_sheet_language.dart';
import 'package:socialapp/widgets/bottom_sheet_theme_mode.dart';
import 'package:socialapp/widgets/error_card.dart';

class GlobalSettingsScreen extends GetView<SettingsController> {
  static const String routeName = "/global_settings";
  const GlobalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ObxValue((v) {
              if (controller.error.value.isNotEmpty) {
                return Column(
                  children: [
                    ErrorCard(error: controller.error.value),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox();
            }, controller.error),
            const SizedBox(height: 5),
            _buildSectionTitle(context, "language".tr),
            _buildListTile(
              context,
              icon: Icons.language,
              title: Get.locale != null
                  ? Get.locale!.languageCode.toLowerCase().startsWith("ar")
                      ? "arabic".tr
                      : "english".tr
                  : "english".tr,
              onTap: () => bottomSheetLanguage(context, controller),
            ),
            Divider(
              thickness: 1,
              color: Get.theme.colorScheme.surface,
            ),
            _buildSectionTitle(
                context, Get.isDarkMode ? "dark_mode".tr : "light_mode".tr),
            _buildListTile(
              context,
              icon: Icons.light_mode,
              title: "light_mode".tr,
              onTap: () => bottomSheetThemeMode(context, controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: context.theme.colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Get.theme.colorScheme.tertiary,
        shadowColor: Get.theme.colorScheme.surface.withOpacity(0.5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}
