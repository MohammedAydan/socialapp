import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';

class VideosPostsController extends GetxController {
  final ManagePostsRepository postRepository;
  ScrollController scrollController = ScrollController();
  final AuthController authController;
  RxInt page = 1.obs;
  RxList<PostModel> posts = RxList<PostModel>([]);
  RxBool loading = true.obs;
  RxBool loadingPosts = true.obs;
  RxBool loadingMorePosts = true.obs;
  RxBool finish = false.obs;
  RxString error = "".obs;

  VideosPostsController(this.postRepository, this.authController);

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
      final res = await postRepository.getPostsByMediaType(
        page: page.value,
        limit: 10,
        mediaType: "video",
      );
      res.fold((l) {
        error(getMessageFromFailure(l));
      }, (r) {
        if (r.isEmpty) {
          finish(true);
        } else {
          posts.addAll(r);
        }
      });
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loadingMorePosts(false);
    }
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

  @override
  void onReady() {
    super.onReady();
    getInitPosts();
    scrollController.addListener(_scrollListener);
  }
}
