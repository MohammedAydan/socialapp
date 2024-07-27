import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/main.dart';

class LikesController extends GetxController {
  final ManagePostsRepository managePostsRepository;
  ScrollController scrollController = ScrollController();
  RxList<UserModel> likes = RxList([]);
  RxBool loadingLikes = true.obs;
  RxBool loadingMoreLikes = false.obs;
  RxBool finish = false.obs;
  RxInt page = 1.obs;
  RxString error = "".obs;

  LikesController(this.managePostsRepository);

  Future<void> getInitLikes() async {
    try {
      loadingLikes(true);
      page(1);
      await getLikes();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingLikes(false);
    }
  }

  Future<void> getLikes() async {
    try {
      finish(false);
      loadingMoreLikes(true);

      final res = await managePostsRepository.getLikes(
        Get.arguments,
        page: page.value,
        limit: 10,
      );
      res.fold(
        (l) => error(getMessageFromFailure(l)),
        (r) {
          if (r.isEmpty) {
            finish(true);
          } else {
            if (page.value == 1) {
              likes.clear();
            }
            likes.addAll(r);
            page.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMoreLikes(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      page(1);
      finish(false);
      await getLikes();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingLikes.value) {
        getLikes();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    final uid = supabase.auth.currentUser?.id;
    if (uid != null) {
      getInitLikes();
      scrollController.addListener(_scrollListener);
    } else {
      loadingLikes(false);
      loadingMoreLikes(false);
    }
  }
}
