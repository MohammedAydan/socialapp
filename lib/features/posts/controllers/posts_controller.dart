import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socialapp/core/UploadMedia/upload_media.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/imagePicker/image_picker.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/local.notifications.dart';
import 'package:socialapp/widgets/loading.dart';

class PostsController extends GetxController {
  final ManagePostsRepository postRepository;
  final ImagePickerRepository imagePickerRepository;
  final GetStorage storage;
  final AuthController authController;
  final UploadMedia _uploadMedia;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerForSuggested = ScrollController();
  RxInt page = 1.obs;
  RxInt pageSuggested = 1.obs;
  RxList<PostModel> posts = RxList<PostModel>([]);
  RxList<PostModel> postsSuggested = RxList<PostModel>([]);
  RxBool loadingPosts = true.obs;
  RxBool loadingPostsSuggested = true.obs;
  RxBool loadingMorePosts = false.obs;
  RxBool loadingMorePostsSuggested = false.obs;
  RxBool finish = false.obs;
  RxBool finishSuggested = false.obs;
  RxString titlePost = "".obs;
  RxString bodyPost = "".obs;
  RxBool publicPost = true.obs;
  RxString filePath = "".obs;
  RxString embedText = "".obs;
  RxString fileType = "".obs;
  RxDouble fileSize = 0.0.obs;
  RxString error = "".obs;
  RxBool isVisibility = true.obs;
  QuillController quillController = QuillController.basic();

  PostsController(
    this.postRepository,
    this.imagePickerRepository,
    this.authController,
    this.storage,
    this._uploadMedia,
  );

  void setInitalPage(int i) => storage.write("INITAL_PAGE", i);
  int getInitalPage() => storage.read("INITAL_PAGE") ?? 0;

  @override
  void onInit() {
    super.onInit();
    getInitPosts();
    scrollController.addListener(_scrollListener);
    initSuggested();
  }

  void initSuggested() {
    getInitPostsSuggested();
    scrollControllerForSuggested.addListener(_scrollListenerForSuggested);
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

  Future<void> getInitPostsSuggested() async {
    try {
      error("");
      loadingPostsSuggested(true);
      await getPostsSuggested();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingPostsSuggested(false);
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

  Future<void> getPostsSuggested() async {
    try {
      error("");
      finishSuggested(false);
      loadingMorePostsSuggested(true);

      final res =
          await postRepository.getPostsSuggested(page: page.value, limit: 10);
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          if (r.isEmpty) {
            finishSuggested(true);
          } else {
            if (page.value == 1) {
              postsSuggested.clear();
            }
            postsSuggested.addAll(r);
            pageSuggested.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMorePostsSuggested(false);
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

  Future<void> refreshPostsSuggested() async {
    try {
      error("");
      pageSuggested(1);
      finishSuggested(false);
      await getPostsSuggested();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isVisibility.value = true;
    }
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isVisibility.value = false;
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingPosts.value) {
        getPosts();
      }
    }
  }

  void _scrollListenerForSuggested() {
    if (scrollControllerForSuggested.position.userScrollDirection ==
        ScrollDirection.forward) {
      isVisibility.value = true;
    }
    if (scrollControllerForSuggested.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isVisibility.value = false;
    }
    if (scrollControllerForSuggested.position.pixels ==
        scrollControllerForSuggested.position.maxScrollExtent) {
      if (!finishSuggested.value && !loadingPostsSuggested.value) {
        getPostsSuggested();
      }
    }
  }

  Future<void> addPost(PostModel post) async {
    // post.body = jsonEncode(quillController.document.toDelta().toJson());
    quillController.clear();
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
        // await pushPostNotification();
        showLoading();

        if (post.mediaType != null &&
            post.mediaType != "embedded" &&
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
        // await cancelPushPostNotification();
      }
    } else {
      error("post_cannot_be_empty".tr);
    }
  }

  // new version of uploadMedia
  Future<String?> uploadMedia(String path) async {
    try {
      error("");
      final publicUrl = await _uploadMedia.uploadMedia(path);
      return publicUrl;
    } catch (e) {
      print(e);
      error(e.toString());
      return null;
    }
  }

  // bad version of uploadMedia
  // Future<String?> uploadMedia(String path) async {
  //   try {
  //     error("");
  //     String uid = authController.user.value?.id ?? "";
  //     String ex = path.split(".").last;
  //     final filePath = "$uid-${DateTime.now().toIso8601String()}.$ex";

  //     await supabase.storage.from("media").upload(
  //           filePath,
  //           File(path),
  //         );

  //     final publicUrl = supabase.storage.from("media").getPublicUrl(filePath);
  //     return publicUrl;
  //   } catch (e) {
  //     print(e);
  //     error(e.toString());
  //     return null;
  //   }
  // }

  void removePost(int id) async {
    posts.removeWhere((p) => p.postId == id);
  }

  @override
  void onClose() {
    scrollController.dispose();
    scrollControllerForSuggested.dispose();
    quillController.dispose();
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
