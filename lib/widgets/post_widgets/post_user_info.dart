import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/user_profile/pages/user_profile_screen.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';
import 'package:socialapp/widgets/custom_secondary_buttom.dart';
import 'package:socialapp/widgets/user_image.dart';

class PostUserInfo extends StatelessWidget {
  PostUserInfo({
    super.key,
    required this.post,
    required this.postController,
    required this.postSharing,
  });

  final PostModel post;
  final AuthController authController = Get.find();
  final PostController postController;
  final bool postSharing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (post.userId != supabase.auth.currentUser?.id) {
              Get.toNamed(
                UserProfileScreen.routeName,
                arguments: "${post.userId}",
              );
            }
          },
          child: Row(
            children: [
              if (post.imageUrl != null)
                UserImage(
                  url: post.imageUrl!,
                  radius: 20,
                )
              else
                CircleAvatar(
                  child: Center(
                    child: Text(post.username?.isNotEmpty == true
                        ? post.username![0].toUpperCase()
                        : ""),
                  ),
                ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(post.username?.isNotEmpty == true
                          ? getUserName()
                          : "unknown_user".tr),
                      const SizedBox(width: 10),
                      if (post.verification == true)
                        Icon(
                          Icons.verified_rounded,
                          size: 20,
                          color: Get.theme.colorScheme.primary,
                        ),
                    ],
                  ),
                  Text(
                    DateTimeFormat.relative(
                      post.createdAt!.toLocal(),
                      ifNow: "now".tr,
                    ),
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!postSharing) ...[
          if (post.userId == authController.user.value?.id &&
              !post.myNewPost!) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: context.theme.colorScheme.surface,
              ),
              child: IconButton(
                onPressed: () {
                  Get.dialog(
                    Dialog(
                      backgroundColor: context.theme.colorScheme.tertiary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "alert".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "are_you_sure_you_want_to_delete_the_post".tr,
                              style: const TextStyle(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: CustomSecondaryButtom(
                                    text: "cancel".tr,
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: CustomPrimaryButton(
                                    text: "delete".tr,
                                    onPressed: () {
                                      Get.back();
                                      postController.handleDelete();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_rounded,
                  color: context.theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  String getUserName() {
    if (post.firstName != null &&
        post.firstName!.isNotEmpty &&
        post.lastName != null &&
        post.lastName!.isNotEmpty) {
      return "${post.firstName} ${post.lastName}";
    }
    return "${post.username}";
  }
}
