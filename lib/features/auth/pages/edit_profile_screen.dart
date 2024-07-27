import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';

class EditProfileScreen extends GetView<AuthController> {
  static const String routeName = "/EditProfile";
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.user.value;
    final fNameController = TextEditingController(text: user?.firstName);
    final lNameController = TextEditingController(text: user?.lastName);
    final phoneController = TextEditingController(text: user?.phone);
    final dayController = TextEditingController(text: user?.day.toString());
    final monthController = TextEditingController(text: user?.month.toString());
    final yearController = TextEditingController(text: user?.year.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "edit_profile".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "first_name".tr,
                        controller: fNameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "last_name".tr,
                        controller: lNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextFormFeild(
                  label: "phone".tr,
                  controller: phoneController,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "day".tr,
                        textInputType: TextInputType.number,
                        controller: dayController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "month".tr,
                        textInputType: TextInputType.number,
                        controller: monthController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormFeild(
                        label: "year".tr,
                        textInputType: TextInputType.number,
                        controller: yearController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          color: context.theme.colorScheme.tertiary,
        ),
        child: CustomPrimaryButton(
          onPressed: () {
            if (fNameController.text.isNotEmpty &&
                lNameController.text.isNotEmpty &&
                phoneController.text.isNotEmpty &&
                dayController.text.isNotEmpty &&
                monthController.text.isNotEmpty &&
                yearController.text.isNotEmpty) {
              controller.updateUser(UserModel(
                userId: user?.userId,
                firstName: fNameController.text.trim(),
                lastName: lNameController.text.trim(),
                phone: phoneController.text.trim(),
                day: int.parse(dayController.text.trim()),
                month: int.parse(monthController.text.trim()),
                year: int.parse(yearController.text.trim()),
              ));
            }
          },
          text: "save".tr,
        ),
      ),
    );
  }
}
