import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/services/repositories/auth_repository.dart';
import 'package:socialapp/main.dart';

class FollowersController extends GetxController {
  final AuthRepository authRepository;
  ScrollController scrollController = ScrollController();
  RxList<UserModel> followers = RxList([]);
  RxBool loadingFollowers = true.obs;
  RxBool loadingMoreFollowers = false.obs;
  RxBool finish = false.obs;
  RxInt page = 1.obs;
  RxString error = "".obs;

  FollowersController(this.authRepository);

  Future<void> getInitFollowers() async {
    try {
      error("");
      loadingFollowers(true);
      page(1);
      await getFollowers();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingFollowers(false);
    }
  }

  Future<void> getFollowers() async {
    try {
      error("");
      finish(false);
      loadingMoreFollowers(true);

      final res = await authRepository.getFollowers(
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
              followers.clear();
            }
            followers.addAll(r);
            page.value++;
          }
        },
      );
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMoreFollowers(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      error("");
      page(1);
      finish(false);
      await getFollowers();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!finish.value && !loadingFollowers.value) {
        getFollowers();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    final uid = supabase.auth.currentUser?.id;
    if (uid != null) {
      getInitFollowers();
      scrollController.addListener(_scrollListener);
    } else {
      loadingFollowers(false);
      loadingMoreFollowers(false);
    }
  }
}
