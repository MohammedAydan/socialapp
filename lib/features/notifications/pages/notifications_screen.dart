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
      controller.markAllAsRead();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("notifications".tr),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Obx(
            () => controller.isLoading.isFalse
                ? IconButton(
                    onPressed: () => controller.fetchInitialNotifications(),
                    icon: const Icon(Icons.refresh_rounded),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value.isNotEmpty) {
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
                    controller.errorMessage.value,
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
                controller.fetchInitialNotifications();
              },
              message: "no_notifications".tr,
              btnText: "refresh".tr,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => await controller.fetchInitialNotifications(),
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
                if (controller.isLoadingMore.value)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}
