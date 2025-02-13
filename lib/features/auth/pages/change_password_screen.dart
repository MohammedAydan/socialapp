import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/layouts/main_layout.dart';
import 'package:socialapp/widgets/error_card.dart';

import '../../../widgets/custom_primary_button.dart';
import '../../../../widgets/custom_text_form_feild.dart';

class ChangePasswordScreen extends GetView<AuthController> {
  static const String routeName = "/ChangePassword";
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final rePasswordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  "change_password".tr,
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
                  label: "enter_password".tr,
                  textInputType: TextInputType.visiblePassword,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                CustomTextFormFeild(
                  label: "enter_re-password".tr,
                  textInputType: TextInputType.visiblePassword,
                  controller: rePasswordController,
                ),
                const SizedBox(height: 30),
                CustomPrimaryButton(
                  text: "change_password".tr,
                  onPressed: () async {
                    await controller.changePassword(
                      passwordController.text,
                      rePasswordController.text,
                    );
                    // if(res == true){
                    //   Get.toNamed(MainLayout.routeName);
                    // }
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
