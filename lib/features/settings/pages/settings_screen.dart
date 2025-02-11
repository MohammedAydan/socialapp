import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';
import 'package:socialapp/widgets/bottom_sheet_account_type.dart';
import 'package:socialapp/widgets/bottom_sheet_language.dart';
import 'package:socialapp/widgets/bottom_sheet_theme_mode.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';
import 'package:socialapp/widgets/error_card.dart';

class SettingsScreen extends GetView<SettingsController> {
  static const String routeName = "/Settings";
  const SettingsScreen({super.key});

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
            Divider(
              thickness: 1,
              color: Get.theme.colorScheme.surface,
            ),
            _buildSectionTitle(context, "account_type".tr),
            Obx(() {
              return _buildListTile(
                context,
                icon: Icons.public_outlined,
                title: controller.accountType.value == "public"
                    ? "public_account".tr
                    : "private_account".tr,
                onTap: () => bottomSheetAccountType(context, controller),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          color: context.theme.colorScheme.tertiary,
        ),
        child: CustomPrimaryButton(
          onPressed: () {
            controller.authController.signOut();
          },
          text: "logout".tr,
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
        shadowColor: Get.theme.colorScheme.surface,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
