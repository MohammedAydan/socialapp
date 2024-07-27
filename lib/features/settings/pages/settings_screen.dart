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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "language".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => bottomSheetLanguage(context, controller),
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.tertiary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 10),
                    Text(
                      Get.locale != null
                          ? Get.locale!.languageCode
                                  .toLowerCase()
                                  .startsWith("ar")
                              ? "arabic".tr
                              : "english".tr
                          : "english".tr,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Get.isDarkMode ? "dark_mode".tr : "light_mode".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => bottomSheetThemeMode(context, controller),
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.tertiary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.light_mode),
                    const SizedBox(width: 10),
                    Text("light_mode".tr),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "account_type".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: context.theme.colorScheme.secondary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => bottomSheetAccountType(context, controller),
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.tertiary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.public_outlined),
                    const SizedBox(width: 10),
                    Obx(
                      () {
                        if (controller.accountType.value == "public") {
                          return Text("public_account".tr);
                        }
                        return Text("private_account".tr);
                      },
                    ),
                  ],
                ),
              ),
            ),
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
}
