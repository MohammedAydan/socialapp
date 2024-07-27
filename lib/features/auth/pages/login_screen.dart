import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/pages/forgot_password_screen.dart';
import 'package:socialapp/features/auth/pages/register_screen.dart';
import 'package:socialapp/global/pages/plans.dart';
import 'package:socialapp/widgets/custom_secondary_buttom.dart';
import 'package:socialapp/widgets/custom_text_buttom.dart';

import '../../../widgets/custom_primary_button.dart';
import '../../../../widgets/custom_text_form_feild.dart';
import '../../../widgets/error_card.dart';

class LoginScreen extends GetView<AuthController> {
  static const String routeName = "/Login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "LOGIN".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
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
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                CustomTextFormFeild(
                  label: "enter_password".tr,
                  controller: passController,
                  obscureText: true,
                ),
                const SizedBox(height: 5),
                CustomTextButtom(
                  text: "forgot_password".tr,
                  onPressed: () {
                    Get.toNamed(ForgotPasswordScreen.routeName);
                  },
                ),
                const SizedBox(height: 10),
                CustomPrimaryButton(
                    text: "login".tr,
                    onPressed: () {
                      if (emailController.text.trim().isEmpty ||
                          passController.text.trim().isEmpty) {
                        controller.error("fill_all_fields".tr);
                        return;
                      }
                      controller.login(
                        emailController.text.trim(),
                        passController.text.trim(),
                      );
                    }),
                const SizedBox(height: 10),
                CustomSecondaryButtom(
                  text: "dont_have_an_account".tr,
                  onPressed: () {
                    Get.toNamed(RegisterScreen.routeName);
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
