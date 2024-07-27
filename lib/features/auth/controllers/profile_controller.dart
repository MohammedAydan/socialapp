import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/imagePicker/image_picker.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/bottom_sheet_select_image.dart';
import 'package:socialapp/widgets/loading.dart';

class ProfileController extends GetxController {
  final AuthController authController;
  final ManagePostsRepository postRepository;
  final ImagePickerRepository imagePickerRepository;
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxList<PostModel>? posts = RxList<PostModel>([]);
  RxBool loading = true.obs;
  RxBool loadingMorePosts = true.obs;
  RxBool finish = false.obs;
  RxString error = "".obs;

  ProfileController(
    this.authController,
    this.postRepository,
    this.imagePickerRepository,
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
      loading.value = true;
      posts?.clear();
      await getPosts();
    } on Failure catch (e) {
      error(getMessageFromFailure(e));
    } finally {
      loading.value = false;
    }
  }

  Future<void> getPosts() async {
    try {
      error("");
      loadingMorePosts(true);
      final res = await postRepository.getPostsByUserId(
        supabase.auth.currentUser!.id,
        page: page.value,
        all: true,
      );
      res.fold((l) {
        error(getMessageFromFailure(l));
      }, (r) {
        if (r.isNotEmpty) {
          posts?.addAll(r);
        } else {
          finish.value = true;
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
      if (!finish.value && !loading.value) {
        page.value++;
        getPosts();
      }
    }
  }

  Future<void> updateUserImage() async {
    final source = await bottomSheetSelectImage();
    if (source == null) {
      return;
    }
    try {
      error("");
      showLoading();
      XFile? file = await imagePickerRepository.pickImage(source: source);
      if (file == null) {
        return;
      }
      final res = await authController.authRepository.updateUserImage(
        file,
        authController.user.value?.imageUrl,
      );
      res.fold((l) {
        // error
        error(getMessageFromFailure(l));
      }, (r) {
        authController.user.value?.imageUrl = r;
      });
    } on Failure catch (e) {
      // // //
      error(getMessageFromFailure(e));
    } finally {
      Get.back();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
