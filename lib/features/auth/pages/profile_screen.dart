import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/formatNumber/format_number.dart';
import 'package:socialapp/features/auth/controllers/profile_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/pages/edit_profile_screen.dart';
import 'package:socialapp/features/auth/pages/show_followers_screen.dart';
import 'package:socialapp/features/auth/pages/show_followings_screen.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/settings/pages/settings_screen.dart';
import 'package:socialapp/global/pages/show_image.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';
import 'package:socialapp/widgets/user_image.dart';

class ProfileScreen extends GetView<ProfileController> {
  static const String routeName = "/Profile";
  ProfileScreen({super.key});

  final MainLayoutController mainLayoutController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mainLayoutController.changeScreen(0);
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: RefreshIndicator(
          onRefresh: () async => controller.fetchInitialPosts(),
          child: ListView(
            controller: controller.scrollController,
            children: [
              const SizedBox(height: 20),
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildPostsSection(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(EditProfileScreen.routeName),
          icon: Icon(Icons.edit, color: Get.theme.colorScheme.primary),
        ),
        IconButton(
          onPressed: () => Get.toNamed(SettingsScreen.routeName),
          icon: Icon(Icons.settings, color: Get.theme.colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final user = controller.authController.user.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.errorMessage.value.isNotEmpty) _buildErrorMessage(),
          _buildUserImageSection(user),
          const SizedBox(height: 20),
          _buildUserNameSection(user),
          const SizedBox(height: 10),
          _buildUsername(user),
          const SizedBox(height: 20),
          _buildFollowCounts(user),
          const SizedBox(height: 20),
          _buildPostsCountSection(user),
        ],
      );
    });
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.red.withOpacity(0.1),
        ),
        child: Text(
          controller.errorMessage.value,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUserImageSection(UserModel? user) {
    return Center(
      child: Stack(
        children: [
          if (user?.imageUrl != null) ...[
            InkWell(
              onTap: () => _navigateToShowImage(user.imageUrl!),
              child: UserImage(url: user!.imageUrl!, radius: 50),
            ),
          ] else ...[
            CircleAvatar(
              radius: 50,
              child: Center(
                child: Text(user?.username?[0].toUpperCase() ?? ''),
              ),
            ),
          ],
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Get.theme.colorScheme.primary,
              ),
              child: IconButton(
                onPressed: () => controller.updateUserImage(),
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowCounts(UserModel? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFollowCount(
          count: user?.followersCount ?? 0,
          label: "followers".tr,
          onTap: () => Get.toNamed(ShowFollowersScreen.routeName),
        ),
        const SizedBox(width: 20),
        _buildFollowCount(
          count: user?.followingCount ?? 0,
          label: "following".tr,
          onTap: () => Get.toNamed(ShowFollowingsScreen.routeName),
        ),
      ],
    );
  }

  Widget _buildFollowCount({
    required int count,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            formatNumber(count),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserNameSection(UserModel? user) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${user?.firstName} ${user?.lastName}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          if (user?.verification == true) ...[
            Icon(
              Icons.verified_rounded,
              size: 20,
              color: Get.theme.colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsername(UserModel? user) {
    return Center(
      child: Text(
        "@${user?.username}",
        style: TextStyle(
          fontSize: 16,
          color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildPostsCountSection(UserModel? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "${formatNumber(user?.postsCount ?? 0)} ${"posts".tr}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPostsSection() {
    return Obx(() {
      if (controller.isLoading.isTrue) {
        return ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => const PostLoading(),
        );
      } else {
        if (controller.posts.isEmpty) {
          return Center(
            child: ErrorCardAndRefreshButton(
              method: () => controller.fetchInitialPosts(),
              message: "no_posts_found".tr,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.posts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return PostCard(post: post);
            },
          );
        }
      }
    });
  }

  void _navigateToShowImage(String imageUrl) {
    Get.to(
      () => const ShowImage(),
      arguments: imageUrl,
      transition: Transition.circularReveal,
    );
  }
}
