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

class ShowPostsSuggestedAndAds extends StatelessWidget {
  const ShowPostsSuggestedAndAds({
    super.key,
    required this.controller,
    required this.maxWidth,
  });

  final PostsController controller;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loadingPostsSuggested.value) {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => const PostLoading(),
        );
      }
      if (controller.postsSuggested.isEmpty &&
          !controller.loadingPostsSuggested.value) {
        return ErrorCardAndRefreshButton(
          method: controller.getInitPostsSuggested,
          message: "no_posts_found".tr,
        );
      }

      return ListView(
        controller: controller.scrollController,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: maxWidth != null ? const EdgeInsets.all(20) : null,
            itemCount: _getTotalItemCount(controller.postsSuggested.length),
            itemBuilder: (context, index) {
              // Ad insertion logic
              if (_isBannerAdPosition(index)) {
                return BannerAdWidget(id: index);
              } else if (_isNativeAdPosition(index)) {
                return NativeAdWidget(id: index);
              }

              // Calculate post index
              int postIndex = _getPostIndex(index);

              if (postIndex >= controller.postsSuggested.length) {
                return const SizedBox.shrink();
              }

              PostModel post = controller.postsSuggested[postIndex];

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
            if (controller.loadingMorePostsSuggested.isTrue) {
              return const PostLoading();
            }
            return const SizedBox();
          }, controller.loadingMorePostsSuggested),
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
