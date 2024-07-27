import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/followings_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/search/widgets/user_card.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';

class ShowFollowingsScreen extends GetView<FollowingsController> {
  const ShowFollowingsScreen({super.key});
  static const String routeName = "/ShowFollowings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("FOLLOWINGS".tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loadingFollowings.value) {
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
        if (controller.followings.isEmpty &&
            !controller.loadingFollowings.value) {
          return ErrorCardAndRefreshButton(
            method: controller.getInitFollowings,
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
                itemCount: controller.followings.length,
                itemBuilder: (context, i) {
                  UserModel user = controller.followings[i];
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
              if (controller.loadingMoreFollowings.value)
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
