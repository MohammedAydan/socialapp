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

  ProfileController(
    this.authController,
    this.postRepository,
    this.imagePickerRepository,
  );

  final ScrollController scrollController = ScrollController();
  final RxInt page = 1.obs;
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMorePosts = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialPosts();
    scrollController.addListener(_onScroll);
  }

  Future<void> fetchInitialPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    posts.clear();
    page.value = 1;
    await fetchPosts();
    isLoading.value = false;
  }

  Future<void> fetchPosts() async {
    if (!hasMorePosts.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    errorMessage.value = '';

    final result = await postRepository.getPostsByUserId(
      supabase.auth.currentUser?.id ?? '',
      page: page.value,
      all: true,
    );

    result.fold(
      (failure) => errorMessage.value = getMessageFromFailure(failure),
      (newPosts) {
        if (newPosts.isNotEmpty) {
          posts.addAll(newPosts);
          page.value++;
        } else {
          hasMorePosts.value = false;
        }
      },
    );

    isLoadingMore.value = false;
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      fetchPosts();
    }
  }

  Future<void> updateUserImage() async {
    final source = await bottomSheetSelectImage();
    if (source == null) return;
    
    try {
      showLoading();
      final XFile? file = await imagePickerRepository.pickImage(source: source);
      if (file == null) return;

      final result = await authController.authRepository.updateUserImage(
        file,
        authController.user.value?.imageUrl,
      );

      result.fold(
        (failure) => errorMessage.value = getMessageFromFailure(failure),
        (newImageUrl) => authController.user.value?.imageUrl = newImageUrl,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      Get.back();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}