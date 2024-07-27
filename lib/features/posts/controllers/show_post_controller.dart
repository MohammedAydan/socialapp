import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:socialapp/features/posts/models/comment_model.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/comments_repository.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';

class ShowPostController extends GetxController {
  final ManagePostsRepository managePostsRepository;
  final CommentsRepository commentsRepository;
  final AuthController authController;
  Rxn<PostModel> post = Rxn(null);
  RxBool isLoading = false.obs;
  final postIdOrPost = Get.arguments;
  RxString error = "".obs;
  ScrollController scrollController = ScrollController();
  RxList<CommentModel> comments = RxList([]);
  RxBool loadingOpComment = false.obs;
  RxBool loadingComments = true.obs;
  RxBool loadingMoreComments = false.obs;
  RxBool finsh = false.obs;
  RxInt page = 1.obs;
  RxString errorComments = "".obs;
  TextEditingController commentEditingController = TextEditingController();
  RxString comment = "".obs;

  ShowPostController(
    this.managePostsRepository,
    this.commentsRepository,
    this.authController,
  );

  Future<void> getInitComments() async {
    try {
      page(1);
      loadingComments(true);
      await getComments();
    } on Failure catch (e) {
      errorComments(getMessageFromFailure(e));
    } finally {
      loadingComments(false);
    }
  }

  Future<void> getComments() async {
    try {
      loadingMoreComments(true);
      final res = await commentsRepository.getComments(
        post.value!.postId.toString(),
        page: page.value,
      );

      res.fold((l) {
        errorComments(getMessageFromFailure(l));
      }, (r) {
        if (page.value == 1) {
          comments.clear();
        }
        comments.addAll(r);
        page.value++;
        finsh.value = r.isEmpty;
      });
    } on Failure catch (e) {
      errorComments(getMessageFromFailure(e));
    } finally {
      loadingMoreComments(false);
    }
  }

  Future<void> addComment() async {
    if (comment.value.isEmpty) {
      return;
    }
    try {
      loadingOpComment(true);
      final res = await commentsRepository.addComment(
        CommentModel(
          postId: post.value?.postId,
          comment: comment.value,
        ),
      );
      // PostController cp = Get.find(tag: post.value?.postId.toString());

      res.fold((l) {
        errorComments(getMessageFromFailure(l));
      }, (r) {
        comment("");
        commentEditingController.clear();
        page(1);
        post.value!.commentsCount += 1;
        // cp.post.value?.commentsCount = cp.post.value!.commentsCount + 1;
        getComments();

        // close keyboard
        // code
      });
    } on Failure catch (e) {
      errorComments(getMessageFromFailure(e));
    } finally {
      loadingOpComment(false);
    }
  }

  Future<void> removeComment(int commentId) async {
    if (commentId == 0) {
      return;
    }
    try {
      loadingOpComment(true);
      final res = await commentsRepository.remove(
        commentId,
        post.value!.postId!,
      );

      // PostController cp = Get.find(tag: post.value?.postId.toString());

      res.fold((l) {
        errorComments(getMessageFromFailure(l));
      }, (r) {
        post.value!.commentsCount -= 1;
        // cp.post.value?.commentsCount = cp.post.value!.commentsCount - 1;
        comments.removeWhere((c) => c.id!.isEqual(commentId));
      });
    } on Failure catch (e) {
      errorComments(getMessageFromFailure(e));
    } finally {
      loadingOpComment(false);
    }
  }

  Future<void> getPost() async {
    try {
      isLoading(true);
      final res = await managePostsRepository.getPost(postIdOrPost!);
      res.fold((l) {
        error(l.toString());
      }, (r) {
        post(r);
        getInitComments();
      });
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      isLoading(false);
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (finsh.isFalse &&
          loadingComments.isFalse &&
          loadingMoreComments.isFalse) {
        getComments();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (postIdOrPost != null) {
      if (postIdOrPost is int) {
        isLoading(true);
        getPost();
      } else {
        post(postIdOrPost);
        getInitComments();
      }
      scrollController.addListener(_scrollListener);
    }
  }
}
