import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/posts/pages/show_post_screen.dart';
import 'package:socialapp/features/user_profile/pages/user_profile_screen.dart';

class NotificationCard extends GetView {
  const NotificationCard({required this.notification, super.key});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    String langCode = Get.locale != null ? Get.locale!.languageCode : "en";

    // Get.put(
    //   NotificationCardController(Get.find(), notification),
    //   tag: "${notification.id}_NOTIFICATION_V1",
    // );

    return GestureDetector(
      onTap: () {
        if (notification.type?.toLowerCase() == "like") {
          Get.toNamed(ShowPostScreen.routeName, arguments: notification.postId);
        } else if (notification.type == "follow") {
          Get.toNamed(
            UserProfileScreen.routeName,
            arguments: notification.myId,
          );
        } else if (notification.type == "comment") {
          Get.toNamed(ShowPostScreen.routeName, arguments: notification.postId);
        } else if (notification.type == "shareing") {
          Get.toNamed(ShowPostScreen.routeName, arguments: notification.postId);
        }
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.theme.colorScheme.tertiary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Center(
                        child: Icon(
                          notification.type == "follow"
                              ? FontAwesome.user_solid
                              : notification.type == "like"
                                  ? FontAwesome.heart_solid
                                  : notification.type == "shareing"
                                      ? FontAwesome.share_solid
                                      : notification.type == "comment"
                                          ? FontAwesome.comment_dots_solid
                                          : Icons.notifications,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${notification.title?[langCode]}"),
                        Text(
                          DateTimeFormat.relative(
                            notification.createdAt!,
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
                const Row(
                  children: [
                    // SizedBox(
                    //   width: 90,
                    //   height: 30,
                    //   child: CustomPrimaryButton(
                    //     text: "Follow",
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Text("${notification.body?[langCode]}"),
          ],
        ),
      ),
    );
  }
}
