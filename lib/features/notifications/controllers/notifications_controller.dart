import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/notifications/services/repositories/notifications_repository.dart';

class NotificationsController extends GetxController {
  final NotificationsRepository notificationsRepository;
  
  RxInt notReaded = 0.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isFinished = false.obs;
  RxString errorMessage = ''.obs;
  ScrollController scrollController = ScrollController();

  NotificationsController(this.notificationsRepository);

  @override
  void onInit() {
    super.onInit();
    fetchInitialNotifications();
    scrollController.addListener(_onScroll);
    OneSignal.Notifications.addForegroundWillDisplayListener(
      (event) {
        if (!isLoading.value && !isLoadingMore.value) {
          fetchNotifications();
        }
      },
    );
  }

  Future<void> fetchInitialNotifications() async {
    isLoading(true);
    notifications.clear();
    page.value = 1;
    isFinished(false);
    await fetchNotifications();
    isLoading(false);
  }

  Future<void> fetchNotifications() async {
    if (isLoadingMore.value || isFinished.value) return;
    
    isLoadingMore(true);
    final res = await notificationsRepository.getMyNotifications(
      page: page.value,
      limit: 20,
    );

    res.fold(
      (failure) => errorMessage(getMessageFromFailure(failure)),
      (newNotifications) {
        if (newNotifications.isEmpty) {
          isFinished(true);
        } else {
          for (var n in newNotifications) {
            if (!n.readed) notReaded.value++;
          }
          notifications.addAll(newNotifications);
        }
      },
    );
    isLoadingMore(false);
  }

  Future<bool> sendNotification(NotificationModel notification) async {
    final res = await notificationsRepository.sendNotification(notification);
    return res.fold((_) => false, (_) => true);
  }

  Future<bool> markAllAsRead() async {
    final res = await notificationsRepository.readedAllNotification();
    return res.fold(
      (_) => false,
      (_) {
        notReaded.value = 0;
        return true;
      },
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      if (!isLoadingMore.value && !isFinished.value) {
        page.value++;
        fetchNotifications();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
