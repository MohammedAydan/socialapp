import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/controllers/shareings_controller.dart';
import 'package:socialapp/features/search/widgets/user_card.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';

class ShowShareingsScreen extends GetView<ShareingsController> {
  const ShowShareingsScreen({super.key});
  static const String routeName = "/ShowShareings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SHAREINGS".tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.loadingShareings.value) {
          return ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: context.theme.colorScheme.surface,
              ),
              title: Container(
                width: 200,
                height: 10,
                decoration: BoxDecoration(
                    color: context.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
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

        if (controller.shareings.isEmpty &&
            !controller.loadingShareings.value) {
          return ErrorCardAndRefreshButton(
            method: controller.getInitShareings,
            message: "not_found".tr,
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.refreshPosts(),
          child: ListView(
            controller: controller.scrollController,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // padding: const EdgeInsets.all(20),
                itemCount: controller.shareings.length,
                itemBuilder: (context, i) {
                  UserModel user = controller.shareings[i];
                  return Center(
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                      ),
                      child: UserCard(user: user),
                    ),
                  );
                },
              ),
              if (controller.loadingMoreShareings.value)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.theme.colorScheme.surface,
                  ),
                  title: Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
