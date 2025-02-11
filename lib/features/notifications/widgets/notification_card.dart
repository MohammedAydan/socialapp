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
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.theme.colorScheme.tertiary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: context.theme.colorScheme.primary,
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
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.title?[langCode]}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateTimeFormat.relative(
                      notification.createdAt!,
                      ifNow: "now".tr,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          context.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${notification.body?[langCode]}",
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
