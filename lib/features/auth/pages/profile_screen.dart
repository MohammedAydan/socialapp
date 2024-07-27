import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/formatNumber/format_number.dart';
import 'package:socialapp/features/auth/controllers/profile_controller.dart';
import 'package:socialapp/features/auth/pages/edit_profile_screen.dart';
import 'package:socialapp/features/auth/pages/show_followers_screen.dart';
import 'package:socialapp/features/auth/pages/show_followings_screen.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/settings/pages/settings_screen.dart';
import 'package:socialapp/global/pages/show_image.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';
import 'package:socialapp/widgets/user_image.dart';

class ProfileScreen extends GetView<ProfileController> {
  static const String routeName = "/Profile";
  ProfileScreen({super.key});
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
          // title: IconButton(
          //   onPressed: () => controller.authController.onReady(),
          //   icon: const Icon(Icons.refresh),
          // ),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(EditProfileScreen.routeName);
              },
              icon: const Icon(Icons.edit_square),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(SettingsScreen.routeName);
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => controller.getPosts(),
          child: ListView(
            controller: controller.scrollController,
            children: [
              const SizedBox(height: 20),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.error.value.isNotEmpty) ...[
                      Column(
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
                      )
                    ],
                    Center(
                      child: Stack(
                        children: [
                          if (controller.authController.user.value?.imageUrl !=
                              null) ...[
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => const ShowImage(),
                                  arguments: controller
                                      .authController.user.value!.imageUrl!,
                                  transition: Transition.circularReveal,
                                );
                              },
                              child: UserImage(
                                url: controller
                                    .authController.user.value!.imageUrl!,
                              ),
                            ),
                          ] else ...[
                            CircleAvatar(
                              radius: 100,
                              child: Center(
                                child: Text(
                                    "${controller.authController.user.value?.username?[0].toUpperCase()}"),
                              ),
                            ),
                          ],
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.theme.colorScheme.tertiary,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  controller.updateUserImage();
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(ShowFollowersScreen.routeName);
                          },
                          child: Text(
                            "${controller.authController.user.value != null ? controller.authController.user.value!.followersCount != null ? controller.authController.user.value!.followersCount == 0 ? controller.authController.user.value!.followersCount : formatNumber(controller.authController.user.value!.followersCount!.toInt()) : "0" : "0"}  ${"followers".tr}",
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Get.toNamed(ShowFollowingsScreen.routeName);
                          },
                          child: Text(
                            "${controller.authController.user.value != null ? controller.authController.user.value!.followingCount != null ? controller.authController.user.value!.followingCount == 0 ? controller.authController.user.value!.followingCount : formatNumber(controller.authController.user.value!.followingCount!.toInt()) : "0" : "0"}  ${"following".tr}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${controller.authController.user.value?.firstName} ${controller.authController.user.value?.lastName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: context.theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (controller
                                  .authController.user.value?.verification ==
                              true) ...[
                            Icon(
                              Icons.verified_rounded,
                              size: 19,
                              color: context.theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "@${controller.authController.user.value?.username}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              context.theme.colorScheme.secondary.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.tertiary,
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            width: 1,
                            color: context.theme.colorScheme.surface,
                          ),
                        ),
                      ),
                      child: Text(
                        "${controller.authController.user.value?.postsCount == 0 ? controller.authController.user.value?.postsCount : formatNumber(controller.authController.user.value!.postsCount!.toInt())} ${"posts".tr}",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.loading.isTrue) {
                  return ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => const PostLoading(),
                  );
                } else {
                  if (controller.posts!.value.isEmpty) {
                    return Center(
                      child: ErrorCardAndRefreshButton(
                        method: () {
                          controller.getInitPosts();
                        },
                        message: "no_posts_found".tr,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: controller.posts?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final post = controller.posts!.value[index];
                        return PostCard(
                          post: post,
                        );
                      },
                    );
                  }
                }
              }),
              Obx(
                () => controller.loadingMorePosts.value
                    ? const PostLoading()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
