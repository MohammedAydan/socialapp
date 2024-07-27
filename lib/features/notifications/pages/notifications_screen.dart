import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/notifications/controllers/notifications_controller.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';

import '../widgets/notification_card.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  static const String routeName = "/Notifications";
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.notReaded > 0) {
      controller.readedAllNotifications();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("notifications".tr),
        centerTitle: true,
        actions: [
          Obx(
            () => controller.loading.isFalse
                ? IconButton(
                    onPressed: () => controller.getInitNotifications(),
                    icon: const Icon(Icons.refresh_rounded),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
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
          if (controller.notifications.isEmpty) {
            return ErrorCardAndRefreshButton(
              method: () {
                controller.getInitNotifications();
              },
              message: "no_notifications".tr,
              btnText: "refresh".tr,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => await controller.getInitNotifications(),
            child: ListView(
              controller: controller.scrollController,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, i) {
                    return NotificationCard(
                      notification: controller.notifications[i],
                    );
                  },
                ),
                if (controller.loadingMorePosts.value)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
