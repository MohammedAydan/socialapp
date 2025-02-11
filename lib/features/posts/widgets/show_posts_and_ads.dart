import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/widgets/banner_ad_widget.dart';
import 'package:socialapp/features/posts/widgets/native_ad_widget.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class ShowPostsAndAds extends StatelessWidget {
  const ShowPostsAndAds({
    super.key,
    required this.controller,
    required this.maxWidth,
  });

  final PostsController controller;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loadingPosts.value) {
        return ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.only(top: 75),
          itemBuilder: (context, index) => const PostLoading(),
        );
      }
      if (controller.posts.isEmpty && !controller.loadingPosts.value) {
        return ErrorCardAndRefreshButton(
          method: controller.getInitPosts,
          message: "no_posts_found".tr,
        );
      }
      return ListView(
        controller: controller.scrollController,
        children: [
          SizedBox(
            height: 75,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: maxWidth != null ? const EdgeInsets.all(20) : null,
            itemCount: _getTotalItemCount(controller.posts.length),
            itemBuilder: (context, index) {
              // Ad insertion logic
              if (_isBannerAdPosition(index)) {
                return BannerAdWidget(id: index);
              } else if (_isNativeAdPosition(index)) {
                return NativeAdWidget(id: index);
              }

              // Calculate post index
              int postIndex = _getPostIndex(index);

              if (postIndex >= controller.posts.length) {
                return const SizedBox.shrink();
              }

              PostModel post = controller.posts[postIndex];

              return Center(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: maxWidth ?? double.infinity,
                  ),
                  child: PostCard(post: post),
                ),
              );
            },
          ),
          ObxValue((v) {
            if (controller.loadingMorePosts.isTrue) {
              return const PostLoading();
            }
            return const SizedBox();
          }, controller.loadingMorePosts),
        ],
      );
    });
  }

  int _getTotalItemCount(int postsLength) {
    int bannerAdCount = postsLength ~/ 3;
    int nativeAdCount = postsLength ~/ 5;
    return postsLength + bannerAdCount + nativeAdCount;
  }

  bool _isBannerAdPosition(int index) {
    return index % 4 == 3;
  }

  bool _isNativeAdPosition(int index) {
    return index % 6 == 5;
  }

  int _getPostIndex(int index) {
    int bannerAdCount = (index + 1) ~/ 4;
    int nativeAdCount = (index + 1) ~/ 6;
    return index - bannerAdCount - nativeAdCount;
  }
}
