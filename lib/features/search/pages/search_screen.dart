import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/search/controllers/search_users_controller.dart';
import 'package:socialapp/widgets/custom_text_form_feild.dart';

import '../widgets/user_card.dart';

class SearchScreen extends GetView<SearchUsersController> {
  SearchScreen({super.key});
  final MainLayoutController mainLayoutController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mainLayoutController.changeScreen(0);
        return await Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormFeild(
                    onChanged: (value) {
                      controller.searchUsers(value);
                    },
                    controller: controller.textEditingController,
                    label: "lable_search_input".tr,
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error.value.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.withOpacity(0.1),
                  ),
                  child: Text(
                    controller.error.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }

          if (controller.users.isEmpty) {
            return Center(
              child: Text("search_result_empty".tr),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 1),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.tertiary,
                ),
                child: IconButton(
                  onPressed: () {
                    controller.users.clear();
                    controller.searchUsers("");
                    controller.textEditingController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, i) {
                    final user = controller.users.value[i];
                    return UserCard(user: user);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
