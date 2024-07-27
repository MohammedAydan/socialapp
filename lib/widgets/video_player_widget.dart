import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.controller,
  });

  final Uri url;
  final PostController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(
            () => AspectRatio(
              aspectRatio: controller
                          .videoPlayerController.value?.value.isInitialized ??
                      false
                  ? controller.videoPlayerController.value!.value.aspectRatio
                  : 16 / 9,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: controller
                            .videoPlayerController.value?.value.isInitialized ??
                        false
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomVideoPlayer(
                          customVideoPlayerController:
                              controller.customVideoPlayerController.value!,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.video_camera_back_outlined,
                          size: 60,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
