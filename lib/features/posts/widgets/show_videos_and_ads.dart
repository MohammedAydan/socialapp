import 'package:flutter/material.dart';
import 'package:socialapp/features/posts/controllers/videos_posts_controller.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/widgets/banner_Ad_widget.dart';
import 'package:socialapp/features/posts/widgets/native_ad_widget.dart';
import 'package:socialapp/widgets/post_widgets/post_card.dart';

class ShowVideosAndAds extends StatelessWidget {
  const ShowVideosAndAds({
    super.key,
    required this.maxWidth,
    required this.controller,
  });

  final double? maxWidth;
  final VideosPostsController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
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
