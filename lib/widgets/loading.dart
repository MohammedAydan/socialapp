import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoading({bool? onWillPop = false}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => await Future.value(onWillPop),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
