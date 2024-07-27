import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/imagePicker/image_picker.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/local.notifications.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/loading.dart';

class PostsController extends GetxController {
  final ManagePostsRepository postRepository;
  final ImagePickerRepository imagePickerRepository;
  final AuthController authController;
  final ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxList<PostModel> posts = RxList<PostModel>([]);
  RxBool loadingPosts = true.obs;
  RxBool loadingMorePosts = false.obs;
  RxBool finish = false.obs;
  RxString titlePost = "".obs;
  RxString bodyPost = "".obs;
  RxBool publicPost = true.obs;
  RxString filePath = "".obs;
  RxString fileType = "".obs;
  RxDouble fileSize = 0.0.obs;
  RxString error = "".obs;

  PostsController(
    this.postRepository,
    this.imagePickerRepository,
    this.authController,
  );

  @override
  void onInit() {
    super.onInit();
    getInitPosts();
    scrollController.addListener(_scrollListener);
  }

  Future<void> getInitPosts() async {
    try {
      error("");
      loadingPosts(true);
      await getPosts();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingPosts(false);
    }
  }

  Future<void> getPosts() async {
    try {
      error("");
      finish(false);
      loadingMorePosts(true);

      final res = await postRepository.getPosts(page: page.value, limit: 10);
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          if (r.isEmpty) {
            finish(true);
          } else {
            if (page.value == 1) {
              posts.clear();
            }
            posts.addAll(r);
            page.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMorePosts(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      error("");
      page(1);
      finish(false);
      await getPosts();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingPosts.value) {
        getPosts();
      }
    }
  }

  Future<void> addPost(PostModel post) async {
    if (post.mediaType!.isNotEmpty && post.mediaUrl!.isNotEmpty) {
      post
        ..mediaType = fileType.value
        ..mediaUrl = filePath.value
        ..mediaSize = fileSize.value
        ..mediaName = filePath.split("/").last;
    }

    if (post.title!.isNotEmpty ||
        post.body!.isNotEmpty ||
        post.sharingPostId != null ||
        post.mediaType!.isNotEmpty ||
        post.mediaUrl!.isNotEmpty) {
      try {
        error("");
        await pushPostNotification();
        showLoading();

        if (post.mediaType != null &&
            post.mediaUrl != null &&
            post.mediaType!.isNotEmpty &&
            post.mediaUrl!.isNotEmpty) {
          final url = await uploadMedia(post.mediaUrl!);
          if (url == null) {
            Get.back();
            error("failed_to_upload_media".tr);
            return;
          }
          post.mediaUrl = url;
        }

        if (post.sharingPostId != null) {
          final pc =
              Get.find<PostController>(tag: post.sharingPostId.toString());
          pc.post.value?.sharingsCount += 1;
        }

        final res = await postRepository.addPost(post);
        res.fold(
          (failure) {
            Get.back();
            error(getMessageFromFailure(failure));
          },
          (newPost) {
            newPost
              ..userId = authController.user.value?.userId
              ..email = authController.user.value?.email
              ..username = authController.user.value?.username
              ..notificationUserId =
                  authController.user.value?.notificationUserId
              ..imageUrl = authController.user.value?.imageUrl
              ..verification = authController.user.value?.verification
              ..myNewPost = true;
            posts.insert(0, newPost);
            titlePost("");
            bodyPost("");
            publicPost = true.obs;
            filePath("");
            fileType("");
            fileSize(0.0);
            Get.back();
            Get.back();
          },
        );
      } on Failure catch (e) {
        print(e);
        Get.back();
        error(getMessageFromFailure(e));
      } finally {
        await cancelPushPostNotification();
      }
    } else {
      error("post_cannot_be_empty".tr);
    }
  }

  Future<String?> uploadMedia(String path) async {
    try {
      error("");
      String uid = authController.user.value?.id ?? "";
      String ex = path.split(".").last;
      final filePath = "$uid-${DateTime.now().toIso8601String()}.$ex";

      await supabase.storage.from("media").upload(
            filePath,
            File(path),
          );

      final publicUrl = supabase.storage.from("media").getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print(e);
      error(e.toString());
      return null;
    }
  }

  void removePost(int id) async {
    posts.removeWhere((p) => p.postId == id);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollOnTopAndRefresh() async {
    if (scrollController.position.pixels !=
        scrollController.position.minScrollExtent) {
      // Scroll to the top
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    // Refresh posts once scrolled to the top
    await refreshPosts();
  }

  Future<void> pushPostNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'progress_channel',
      'Progress Channel',
      channelDescription: 'Progress channel description',
      channelShowBadge: false,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      onlyAlertOnce: false,
      showProgress: true,
      autoCancel: false,
      visibility: NotificationVisibility.public,
      indeterminate: true,
      enableVibration: true,
      ongoing: true,
      playSound: true,
      showWhen: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      1,
      '',
      // 'posted'.tr,
      "${'posted_in_progress'.tr}...",
      notificationDetails,
      payload: 'item x',
    );
  }

  Future<void> cancelPushPostNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }
}
