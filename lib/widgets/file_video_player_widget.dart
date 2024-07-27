import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileVideoPlayerWidget extends StatelessWidget {
  const FileVideoPlayerWidget({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    final FileVideoController controller = Get.put(
      FileVideoController(path, context),
    );
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

class FileVideoController extends GetxController {
  final videoPlayerController = Rxn<VideoPlayerController>();
  final customVideoPlayerController = Rxn<CustomVideoPlayerController>();
  final String videoPath;
  final BuildContext context;

  FileVideoController(this.videoPath, this.context);

  @override
  void onInit() {
    super.onInit();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    videoPlayerController.value = VideoPlayerController.file(File(videoPath));
    await videoPlayerController.value!.initialize().then(
      (value) {
        videoPlayerController.refresh();
        customVideoPlayerController.refresh();
      },
    );
    customVideoPlayerController.value = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController.value!,
    );
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    customVideoPlayerController.value?.dispose();
    super.onClose();
  }
}
