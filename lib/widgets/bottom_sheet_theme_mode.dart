import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';

Future<dynamic> bottomSheetThemeMode(
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
            onTap: () => controller.changeMode(false),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.light_mode),
                  SizedBox(width: 10),
                  Text("light_mode".tr),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.changeMode(true),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.dark_mode_rounded),
                  SizedBox(width: 10),
                  Text("dark_mode".tr),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 5),
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //     decoration: BoxDecoration(
          //       color: context.theme.colorScheme.tertiary,
          //     ),
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Icon(Icons.auto_awesome),
          //         SizedBox(width: 10),
          //         Text("System mode"),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    ),
  );
}
