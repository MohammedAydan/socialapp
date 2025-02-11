import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/posts/controllers/videos_posts_controller.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import '../widgets/show_videos.dart';
import '../widgets/show_videos_and_ads.dart';

class VideosScreen extends GetView<VideosPostsController> {
  static const String routeName = "/Videos";
  VideosScreen({super.key, this.maxWidth});
  final MainLayoutController mainLayoutController = Get.find();
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mainLayoutController.changeScreen(0);
        return await Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("videos".tr),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () async => controller.getPosts(),
          child: Obx(
            () {
              if (controller.loadingPosts.value) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => const PostLoading(),
                );
              }

              if (controller.error.value.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.withOpacity(0.1),
                      ),
                      child: Text(
                        controller.error.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }
              if (controller.posts.isEmpty) {
                return ErrorCardAndRefreshButton(
                  message: "no_videos".tr,
                  method: controller.onReady,
                );
              }
              return ListView(
                controller: controller.scrollController,
                children: [
                  (controller.authController.user.value?.basicPlan == true ||
                          controller.authController.user.value?.plusPlan ==
                              true)
                      ? ShowVideos(maxWidth: maxWidth, controller: controller)
                      : ShowVideosAndAds(
                          maxWidth: maxWidth,
                          controller: controller,
                        ),
                  controller.loadingMorePosts.value
                      ? const PostLoading()
                      : const SizedBox(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
