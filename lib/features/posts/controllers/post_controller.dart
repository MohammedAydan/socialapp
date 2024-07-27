import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/notifications/controllers/notifications_controller.dart';
import 'package:socialapp/features/notifications/models/notification_model.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/features/posts/services/repositories/post_repository.dart';
import 'package:socialapp/onesignal_notification.dart';
import 'package:socialapp/widgets/loading.dart';
import 'package:voice_message_package/voice_message_package.dart';

class PostController extends GetxController {
  final ManagePostsRepository managePostsRepository;
  final PostRepository postRepository;
  final OneSignalNotificationsP oneSignalNotificationsP;
  final AuthController authController;
  final NotificationsController notificationsController;
  Rxn<PostModel> post = Rxn<PostModel>(null);
  RxBool showFullPost = false.obs;
  final videoPlayerController = Rxn<VideoPlayerController>();
  final customVideoPlayerController = Rxn<CustomVideoPlayerController>();
  final voiceController = Rxn<VoiceController>();
  Rxn<PostModel> postShareing = Rxn<PostModel>(null);
  RxBool isLoading = true.obs;
  RxString error = "".obs;

  PostController(
    this.managePostsRepository,
    this.postRepository,
    this.oneSignalNotificationsP,
    this.authController,
    this.notificationsController,
    PostModel postModel,
  ) {
    post.value = postModel;
  }

  void handleToggleFullPost() {
    showFullPost.value = !showFullPost.value;
  }

  Future addOrRemoveLike() async {
    try {
      error("");
      final likesCount = post.value!.likesCount;
      if (post.value != null && post.value!.isLikes! == null ||
          post.value!.isLikes! == false) {
        post.value!.likesCount = likesCount + 1;
        post.value!.isLikes = !post.value!.isLikes!;
        post.refresh();

        final add = await postRepository.addLike(
          post.value!.postId!.toString(),
        );

        add.fold((l) {
          error(getMessageFromFailure(l));
        }, (r) async {
          if (authController.user.value?.notificationUserId !=
              post.value!.notificationUserId) {
            await oneSignalNotificationsP.postNotification(OSCreateNotification(
              playerIds: [post.value!.notificationUserId.toString()],
              headingEn: "Like",
              headingAr: "أعجب",
              contentEn:
                  "${authController.user.value?.username} liked your post",
              contentAr: "${authController.user.value?.username} أعجب بمنشورك",
              androidAccentColor: "b72222",
              data: {
                "postId": post.value!.postId.toString(),
                "type": "like",
              },
            ));
            await notificationsController.sendNotification(
              NotificationModel(
                userId: post.value!.userId,
                title: {
                  "en": "Like",
                  "ar": "أعجب",
                },
                body: {
                  "en":
                      "${authController.user.value?.username} liked your post",
                  "ar": "${authController.user.value?.username} أعجب بمنشورك",
                },
                postId: post.value!.postId,
                type: "like",
              ),
            );
          }
        });
      } else {
        post.value!.likesCount = likesCount - 1;
        post.value!.isLikes = !post.value!.isLikes!;
        post.refresh();

        final remove = await postRepository.removeLike(
          post.value!.postId!.toString(),
        );

        remove.fold((l) {
          error(getMessageFromFailure(l));
        }, (r) {
          // remove like success code
        });
      }
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  Future<void> getPost() async {
    try {
      error("");
      isLoading(true);
      final res =
          await managePostsRepository.getPost(post.value!.sharingPostId!);
      res.fold((l) {
        // error(l.toString());
      }, (r) {
        postShareing(r);
      });
    } on Failure catch (e) {
      // error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleDelete() async {
    try {
      error("");
      showLoading();
      final res = await managePostsRepository.deletePost(post.value!);
      res.fold((l) {
        Get.back();
        error(getMessageFromFailure(l));
      }, (r) {
        (Get.find<PostsController>()).removePost(post.value!.postId!);
        post(null);
        Get.back();
      });
    } on Failure catch (e) {
      Get.back();
      error(getMessageFromFailure(e));
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (post.value != null) {
      if (post.value?.sharingPostId != null) {
        getPost();
      }
    }
    if (Get.context != null &&
        post.value?.mediaType != null &&
        post.value!.mediaType!.contains("video")) {
      videoPlayerController.value = VideoPlayerController.network(
        post.value?.mediaUrl ?? "",
      )..initialize().then((_) {
          videoPlayerController.refresh();
          customVideoPlayerController.refresh();
        });

      customVideoPlayerController.value = CustomVideoPlayerController(
        context: Get.context!,
        videoPlayerController: videoPlayerController.value!,
      );
    }
    if (post.value?.mediaType != null &&
        post.value!.mediaType!.contains("audio")) {
      voiceController.value = VoiceController(
        audioSrc: post.value?.mediaUrl ?? "",
        onComplete: () {
          /// do something on complete
        },
        onPause: () {
          /// do something on pause
        },
        onPlaying: () {
          /// do something on playing
        },
        onError: (err) {
          /// do somethin on error
        },
        maxDuration: const Duration(seconds: 10),
        isFile: false,
      )..init().then((_) => voiceController.refresh());
    }
  }

  @override
  void dispose() {
    customVideoPlayerController.value?.dispose();
    videoPlayerController.value?.dispose();
    super.dispose();
  }
}
