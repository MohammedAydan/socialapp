import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/notifications/services/repositories/notifications_repository.dart';

class NotificationsController extends GetxController {
  final NotificationsRepository notificationsRepository;
  RxInt notReaded = RxInt(0);
  ScrollController scrollController = ScrollController();
  RxList<NotificationModel> notifications = RxList<NotificationModel>([]);
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxBool loadingMorePosts = false.obs;
  RxBool finish = false.obs;
  RxString error = "".obs;

  NotificationsController(this.notificationsRepository);

  Future<void> getInitNotifications() async {
    try {
      error("");
      loading(true);
      notifications.clear();
      await getNotifications();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loading(false);
    }
  }

  Future<void> getNotifications() async {
    try {
      error("");
      loadingMorePosts(true);
      final res = await notificationsRepository.getMyNotifications(
        page: page.value,
        limit: 20,
      );
      res.fold((l) {
        error(getMessageFromFailure(l));
      }, (r) {
        if (r.isNotEmpty) {
          for (var n in r) {
            if (!n.readed) {
              notReaded.value++;
            }
          }

          notifications.addAll(r);
        } else {
          finish.value = true;
        }
      });
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMorePosts(false);
    }
  }

  Future<bool> sendNotification(NotificationModel notification) async {
    try {
      error("");
      final res = await notificationsRepository.sendNotification(notification);
      res.fold((l) {
        return false;
      }, (r) {
        return true;
      });
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> readedAllNotifications() async {
    try {
      error("");
      final res = await notificationsRepository.readedAllNotification();
      res.fold((l) {
        return false;
      }, (r) {
        notReaded.value = 0;
        return true;
      });
      return false;
    } catch (e) {
      return false;
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!loadingMorePosts.value && !finish.value) {
        page.value++;
        getNotifications();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    loading(true);
    loadingMorePosts(true);
    getInitNotifications();
    scrollController.addListener(_scrollListener);
    OneSignal.Notifications.addForegroundWillDisplayListener(
      (event) {
        if (loadingMorePosts.isFalse && loading.isFalse) {
          getNotifications();
        }
      },
    );
  }
}
