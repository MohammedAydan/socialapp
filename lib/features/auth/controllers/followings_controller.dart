import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/services/repositories/auth_repository.dart';
import 'package:socialapp/main.dart';

class FollowingsController extends GetxController {
  final AuthRepository authRepository;
  ScrollController scrollController = ScrollController();
  RxList<UserModel> followings = RxList([]);
  RxBool loadingFollowings = true.obs;
  RxBool loadingMoreFollowings = false.obs;
  RxBool finish = false.obs;
  RxInt page = 1.obs;
  RxString error = "".obs;

  FollowingsController(this.authRepository);

  Future<void> getInitFollowings() async {
    try {
      error("");
      loadingFollowings(true);
      page(1);
      await getFollowings();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingFollowings(false);
    }
  }

  Future<void> getFollowings() async {
    try {
      error("");
      finish(false);
      loadingMoreFollowings(true);

      final res = await authRepository.getFollowings(
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
              followings.clear();
            }
            followings.addAll(r);
            page.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMoreFollowings(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      error("");
      page(1);
      finish(false);
      await getFollowings();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingFollowings.value) {
        getFollowings();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    final uid = supabase.auth.currentUser?.id;
    if (uid != null) {
      getInitFollowings();
      scrollController.addListener(_scrollListener);
    } else {
      loadingFollowings(false);
      loadingMoreFollowings(false);
    }
  }
}
