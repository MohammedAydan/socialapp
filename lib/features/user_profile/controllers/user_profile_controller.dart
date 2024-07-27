import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/notifications/controllers/notifications_controller.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/features/user_profile/services/repositories/user_profile_repository.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/onesignal_notification.dart';

class UserProfileController extends GetxController {
  final UserProfileRepository userProfileRepository;
  final ManagePostsRepository postRepository;
  final OneSignalNotificationsP oneSignalNotificationsP;
  final AuthController authController;
  final NotificationsController notificationsController;

  UserProfileController(
    this.userProfileRepository,
    this.postRepository,
    this.oneSignalNotificationsP,
    this.authController,
    this.notificationsController,
  );

  Rxn<UserModel> user = Rxn<UserModel>();
  RxBool isFollow = false.obs;
  RxBool isFollowRequest = false.obs;
  RxBool isInitLoading = true.obs;
  RxBool isLoading = false.obs;
  RxBool requestToFollowYou = false.obs;
  RxBool isLoadingFollowReq = false.obs;
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxList<PostModel> posts = RxList<PostModel>([]);
  RxBool loadingPosts = false.obs;
  RxBool loadingMorePosts = false.obs;
  RxBool finish = false.obs;
  RxString error = "".obs;

  late RxString userId;
  late RxString myId;

  @override
  void onInit() {
    super.onInit();
    userId = (Get.arguments as String).obs;
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      myId = currentUser.id.obs;
    } else {
      myId = ''.obs;
      error("current_user_is_not_logged_in".tr);
    }
    if (userId.value.isNotEmpty) {
      getUser();
      handleCheckRequestToFollowYou();
      checkIsFollow();
    }
  }

  Future<void> getUser() async {
    try {
      error("");
      isInitLoading(true);
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isInitLoading(false);
    }
  }

  Future<void> _getUser() async {
    try {
      error("");
      final res = await userProfileRepository.getUser(userId.value);
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          user.value = r;
          if (checkIsPublicAccount() || isFollow.isTrue) {
            getInitPosts();
            scrollController.addListener(_scrollListener);
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  Future<void> handleCheckRequestToFollowYou() async {
    try {
      error("");
      isLoadingFollowReq(true);
      final res = await userProfileRepository.checkRequestToFollowYou(
        userId.value,
        myId.value,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) => requestToFollowYou(r?.status == false),
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoadingFollowReq(false);
    }
  }

  Future<void> checkIsFollow() async {
    try {
      error("");
      isLoading(true);
      final res = await userProfileRepository.isFollowOrFollowRequest(
        myId.value,
        userId.value,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          if (r == null) {
            isFollow(false);
            isFollowRequest(false);
          } else {
            isFollow(r.status == true);
            isFollowRequest(r.status == false);
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleFollow() async {
    try {
      error("");
      isLoading(true);
      final res = user.value?.accountType == "public"
          ? await userProfileRepository.addFollow(userId.value, myId.value)
          : await userProfileRepository.addFollowRequest(
              userId.value,
              myId.value,
            );

      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) async {
          isFollow(user.value?.accountType == "public");
          isFollowRequest(user.value?.accountType != "public");
          int followingCount = authController.user.value?.followingCount ?? 0;
          authController.user.value?.followingCount = followingCount + 1;
          await notificationsController.sendNotification(
            NotificationModel(
              userId: userId.value,
              title: {
                "en": "Follow",
                "ar": "متابعة",
              },
              body: {
                "en": user.value?.accountType == "public"
                    ? "Following from ${authController.user.value?.username}"
                    : "Request following from ${authController.user.value?.username}",
                "ar": user.value?.accountType == "public"
                    ? "متابعة من ${authController.user.value?.username}"
                    : "طلب المتابعة من ${authController.user.value?.username}",
              },
              type: "follow",
            ),
          );
          await oneSignalNotificationsP.postNotification(
            OSCreateNotification(
              playerIds: [user.value?.notificationUserId ?? ""],
              contentEn: user.value?.accountType == "public"
                  ? "Following from ${authController.user.value?.username}"
                  : "Request Following from ${authController.user.value?.username}",
              contentAr: user.value?.accountType == "public"
                  ? "متابعة من ${authController.user.value?.username}"
                  : "طلب المتابعة من ${authController.user.value?.username}",
              headingEn: "Follow",
              headingAr: "متابعة",
              androidAccentColor: "b72222",
              data: {
                "user_id": user.value?.id,
                "type": "follow",
              },
            ),
          );
        },
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleUnfollow() async {
    try {
      error("");
      isLoading(true);
      final res = await userProfileRepository.removeFollowOrFollowRequest(
        userId.value,
        myId.value,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          isFollow(false);
          isFollowRequest(false);
          int followingCount = authController.user.value?.followingCount ?? 0;
          authController.user.value?.followingCount = followingCount - 1;
        },
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleCancelRequest() async {
    try {
      error("");
      isLoading(true);
      final res = await userProfileRepository.removeFollowOrFollowRequest(
        userId.value,
        myId.value,
      );

      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          isFollow(false);
          isFollowRequest(false);
        },
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleRejectFollowRequest() async {
    try {
      error("");
      isLoadingFollowReq(true);
      final res = await userProfileRepository.rejectFollowRequest(
        userId.value,
        myId.value,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) => requestToFollowYou(false),
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoadingFollowReq(false);
    }
  }

  Future<void> handleAcceptedFollowRequest() async {
    try {
      error("");
      isLoadingFollowReq(true);
      final res = await userProfileRepository.acceptFollowRequest(
        userId.value,
        myId.value,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) => requestToFollowYou(false),
      );
      await _getUser();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoadingFollowReq(false);
    }
  }

  Future<void> getInitPosts() async {
    try {
      error("");
      loadingPosts.value = true;
      posts.clear();
      await getPosts();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingPosts.value = false;
    }
  }

  Future<void> getPosts() async {
    try {
      error("");
      loadingMorePosts.value = true;
      final res = await postRepository.getPostsByUserId(
        userId.value,
        page: page.value,
        isPublic: checkIsPublicAccount(),
        all: false,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          if (r.isNotEmpty) {
            posts.addAll(r);
          } else {
            finish.value = true;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMorePosts.value = false;
    }
  }

  bool checkIsPublicAccount() {
    return user.value?.accountType?.toLowerCase() == "public";
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingPosts.value) {
        page.value++;
        getPosts();
      }
    }
  }
}
