import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';

Future<dynamic> bottomSheetLanguage(
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
            onTap: () => controller.changeLang("en"),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 10),
                  Text("english".tr),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.changeLang("ar"),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 10),
                  Text("arabic".tr),
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
