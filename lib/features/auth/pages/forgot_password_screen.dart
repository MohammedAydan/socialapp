import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/pages/verifide_email_screen.dart';
import 'package:socialapp/widgets/error_card.dart';

import '../../../widgets/custom_primary_button.dart';
import '../../../../widgets/custom_text_form_feild.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  static const String routeName = "/ForgotPassword";
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "forgot_password".tr,
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
                  label: "enter_email".tr,
                  textInputType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                const SizedBox(height: 30),
                CustomPrimaryButton(
                  text: "send_email".tr,
                  onPressed: () async {
                    if (EmailValidator.validate(emailController.text) ==
                        false) {
                      controller.error("invalid_email".tr);
                      return;
                    }
                    final res = await controller.sendOTP(emailController.text);
                    if (res == true) {
                      Get.toNamed(
                        VerifideEmailScreen.routeName,
                        arguments: emailController.text,
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
