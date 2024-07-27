import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/main.dart';

class ShareingsController extends GetxController {
  final ManagePostsRepository managePostsRepository;
  ScrollController scrollController = ScrollController();
  RxList<UserModel> shareings = RxList([]);
  RxBool loadingShareings = true.obs;
  RxBool loadingMoreShareings = false.obs;
  RxBool finish = false.obs;
  RxInt page = 1.obs;
  RxString error = "".obs;

  ShareingsController(this.managePostsRepository);

  Future<void> getInitShareings() async {
    try {
      error("");
      loadingShareings(true);
      page(1);
      await getShareings();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingShareings(false);
    }
  }

  Future<void> getShareings() async {
    try {
      error("");
      finish(false);
      loadingMoreShareings(true);

      final res = await managePostsRepository.getShareings(
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
              shareings.clear();
            }
            shareings.addAll(r);
            page.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMoreShareings(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      error("");
      page(1);
      finish(false);
      await getShareings();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingShareings.value) {
        getShareings();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    final uid = supabase.auth.currentUser?.id;
    if (uid != null) {
      getInitShareings();
      scrollController.addListener(_scrollListener);
    } else {
      loadingShareings(false);
      loadingMoreShareings(false);
    }
  }
}
