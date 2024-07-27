import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/pages/change_password_screen.dart';
import 'package:socialapp/widgets/error_card.dart';

import '../../../widgets/custom_primary_button.dart';
import '../../../../widgets/custom_text_form_feild.dart';

class VerifideEmailScreen extends GetView<AuthController> {
  static const String routeName = "/VerifideEmail";
  const VerifideEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "verifide_email".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                ObxValue((v) {
                  if (controller.error.value.isNotEmpty) {
                    return ErrorCard(error: controller.error.value);
                  }
                  return const SizedBox();
                }, controller.error),
                const SizedBox(height: 10),
                CustomTextFormFeild(
                  label: "enter_code".tr,
                  controller: otpController,
                ),
                const SizedBox(height: 30),
                CustomPrimaryButton(
                  text: "verifide".tr,
                  onPressed: () async {
                    final res = await controller.verifyOTP(
                      Get.arguments,
                      otpController.text,
                    );
                    if (res == true) {
                      Get.offAllNamed(
                        ChangePasswordScreen.routeName,
                        arguments: Get.arguments,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
