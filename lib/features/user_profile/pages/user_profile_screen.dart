import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/formatNumber/format_number.dart';
import 'package:socialapp/di/di.dart';
import 'package:socialapp/features/user_profile/controllers/user_profile_controller.dart';
import 'package:socialapp/global/pages/show_image.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';
import 'package:socialapp/widgets/user_image.dart';

import '../../../widgets/error_card_and_refresh_button.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = "/UserProfile";
  UserProfileScreen({super.key});

  final UserProfileController controller = Get.put(UserProfileController(
    sl(),
    sl(),
    sl(),
    Get.find(),
    Get.find(),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isInitLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
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
          if (controller.user.value == null) {
            return ErrorCardAndRefreshButton(
              message: "not_found".tr,
              method: controller.onReady,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => controller.onInit(),
            child: ListView(
              controller: controller.scrollController,
              children: [
                const SizedBox(height: 20),
                if (controller.user.value?.imageUrl != null) ...[
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => const ShowImage(),
                        arguments: controller.user.value!.imageUrl!,
                        transition: Transition.circularReveal,
                      );
                    },
                    child: Center(
                      child: UserImage(
                        url: controller.user.value!.imageUrl!,
                      ),
                      // CircleAvatar(
                      //   radius: 100,
                      //   backgroundImage: NetworkImage(
                      //     controller.user.value!.imageUrl!,
                      //   ),
                      // ),
                    ),
                  ),
                ] else ...[
                  CircleAvatar(
                    radius: 100,
                    child: Center(
                      child: Text(
                          "${controller.user.value?.username?[0].toUpperCase()}"),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${controller.user.value != null ? controller.user.value!.followersCount != null ? formatNumber(controller.user.value!.followersCount!.toInt()) : "0" : "0"} ${"followers".tr}",
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${controller.user.value != null ? controller.user.value!.followingCount != null ? formatNumber(controller.user.value!.followingCount!.toInt()) : "0" : "0"} ${"following".tr}",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.user.value?.firstName} ${controller.user.value?.lastName}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (controller.user.value?.verification == true) ...[
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
                    "@${controller.user.value?.username}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.secondary.withOpacity(
                        0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoadingFollowReq.value) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      height: 70,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: context.theme.colorScheme.surface,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    if (controller.requestToFollowYou.isFalse) {
                      return const SizedBox();
                    }
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text("follow_request".tr),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomPrimaryButton(
                                  text: "accept".tr,
                                  onPressed: () {
                                    controller.handleAcceptedFollowRequest();
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomPrimaryButton(
                                  text: "reject".tr,
                                  onPressed: () {
                                    controller.handleRejectFollowRequest();
                                  },
                                  bgColor: context.theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        if (!controller.isFollow.value &&
                            !controller.isFollowRequest.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomPrimaryButton(
                                    text: "follow".tr,
                                    onPressed: () => controller.handleFollow(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.isFollow.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomPrimaryButton(
                                    text: "unfollow".tr,
                                    onPressed: () =>
                                        controller.handleUnfollow(),
                                    bgColor:
                                        context.theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (controller.isFollowRequest.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomPrimaryButton(
                                    text: "cancel_request".tr,
                                    onPressed: () =>
                                        controller.handleCancelRequest(),
                                    bgColor:
                                        context.theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 10),
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
                    "${controller.user.value?.postsCount == 0 ? controller.user.value?.postsCount : formatNumber(controller.user.value!.postsCount!.toInt())} ${"posts".tr}",
                  ),
                ),
                const SizedBox(height: 10),
                if (controller.checkIsPublicAccount() ||
                    controller.isFollow.isTrue) ...[
                  if (!controller.loadingPosts.value) ...[
                    ListView.builder(
                      itemCount: controller.posts.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) => PostCard(
                        post: controller.posts.value[i],
                      ),
                    ),
                  ],
                  if (controller.loadingPosts.value) ...[
                    ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => const PostLoading(),
                    ),
                  ],
                  if (controller.loadingMorePosts.value) ...[
                    const PostLoading(),
                  ],
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.public_off),
                        const SizedBox(width: 10),
                        Text("private_account".tr),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }
      }),
    );
  }
}
