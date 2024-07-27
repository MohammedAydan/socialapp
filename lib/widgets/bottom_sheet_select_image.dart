import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> bottomSheetSelectImage() async {
  ImageSource? source;
  await Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              source = ImageSource.camera;
              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.tertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.camera),
                  const SizedBox(width: 10),
                  Text("camera".tr),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              source = ImageSource.gallery;
              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.tertiary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.image),
                  const SizedBox(width: 10),
                  Text("gallery".tr),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Get.theme.colorScheme.tertiary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
  );
  return source;
}
