import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';

Future<dynamic> bottomSheetAccountType(
    BuildContext context, SettingsController controller) {
  return showModalBottomSheet(
    backgroundColor: context.theme.colorScheme.tertiary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => controller.changeAccountType("public"),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.public),
                  const SizedBox(width: 10),
                  Text("public_account".tr),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.changeAccountType("private"),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.public_off_rounded),
                  const SizedBox(width: 10),
                  Text("private_account".tr),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
