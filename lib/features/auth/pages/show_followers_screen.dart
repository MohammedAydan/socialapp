import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/followers_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/search/widgets/user_card.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';

class ShowFollowersScreen extends GetView<FollowersController> {
  const ShowFollowersScreen({super.key});
  static const String routeName = "/ShowFollowers";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("FOLLOWERS".tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loadingFollowers.value) {
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }
        if (controller.followers.isEmpty &&
            !controller.loadingFollowers.value) {
          return ErrorCardAndRefreshButton(
            method: controller.getInitFollowers,
            message: controller.error.value.tr,
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.refreshPosts(),
          child: ListView(
            controller: controller.scrollController,
            children: [
              ObxValue((v) {
                if (controller.error.value.isNotEmpty) {
                  return Column(
                    children: [
                      ErrorCard(error: controller.error.value),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return const SizedBox();
              }, controller.error),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // padding: const EdgeInsets.all(20),
                itemCount: controller.followers.length,
                itemBuilder: (context, i) {
                  UserModel user = controller.followers[i];
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
              if (controller.loadingMoreFollowers.value)
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
