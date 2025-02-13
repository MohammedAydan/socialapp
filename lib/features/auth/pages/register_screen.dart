import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/widgets/gender_drop_down_menu.dart';
import 'package:socialapp/global/pages/custom_browser.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../widgets/custom_primary_button.dart';
import '../../../../widgets/custom_text_form_feild.dart';

class RegisterScreen extends GetView<AuthController> {
  static const String routeName = "/Register";
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.theme.colorScheme.primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Text(
                    "register".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ObxValue((v) {
                  if (controller.error.value.isNotEmpty) {
                    return ErrorCard(error: controller.error.value);
                  }
                  return const SizedBox();
                }, controller.error),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "first_name".tr,
                        onChanged: (v) => controller.fName(v),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "last_name".tr,
                        onChanged: (v) => controller.lName(v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  label: "enter_username".tr,
                  onChanged: (v) => controller.username(v),
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  label: "enter_email".tr,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (v) => controller.email(v),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => GenderDropDownMenu(
                    value: controller.gender.value.isEmpty
                        ? null
                        : controller.gender.value,
                    onChange: (v) => controller.gender(v),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "enter_date_of_birth".tr,
                  style: TextStyle(
                    color: context.theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "day".tr,
                        textInputType: TextInputType.number,
                        onChanged: (v) => controller.day(v),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "month".tr,
                        textInputType: TextInputType.number,
                        onChanged: (v) => controller.month(v),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "year".tr,
                        textInputType: TextInputType.number,
                        onChanged: (v) => controller.year(v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  label: "enter_country".tr,
                  onChanged: (v) => controller.country(v),
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  label: "enter_password".tr,
                  textInputType: TextInputType.visiblePassword,
                  onChanged: (v) => controller.pass(v),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  label: "enter_re-password".tr,
                  textInputType: TextInputType.visiblePassword,
                  onChanged: (v) => controller.repass(v),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ObxValue(
                      (v) => Checkbox(
                        value: v.value,
                        onChanged: (v) => controller.termsAndConditions(v),
                      ),
                      controller.termsAndConditions,
                    ),
                    Expanded(
                      child: Text(
                        "i_agree_to_the".tr,
                        style: TextStyle(
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final url =
                            "https://mohammedaydan.github.io/SOCIAL/POLICES/";

                        // await launchUrlString(
                        //   "https://mohammedaydan.github.io/SOCIAL/POLICES/",
                        //   mode: LaunchMode.inAppBrowserView,
                        //   browserConfiguration: const BrowserConfiguration(
                        //     showTitle: true,
                        //   ),
                        // );

                        Get.to(() => CustomBrowser(url: url));
                      },
                      child: Text(
                        "terms_and_conditions".tr,
                        style: TextStyle(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ObxValue(
                  (v) => CustomPrimaryButton(
                    text: "register".tr,
                    onPressed: v.isFalse ||
                            controller.fName.value.isEmpty ||
                            controller.lName.value.isEmpty ||
                            controller.username.value.isEmpty ||
                            controller.email.value.isEmpty ||
                            controller.day.value.isEmpty ||
                            controller.month.value.isEmpty ||
                            controller.year.value.isEmpty ||
                            controller.country.value.isEmpty ||
                            controller.pass.value.isEmpty ||
                            controller.repass.value.isEmpty
                        ? null
                        : () {
                            controller.register();
                          },
                  ),
                  controller.termsAndConditions,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
