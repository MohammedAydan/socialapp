import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FileVideoPlayerWidget extends StatelessWidget {
  const FileVideoPlayerWidget({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    final FileVideoController controller = Get.put(FileVideoController(path));

    return Obx(
      () {
        if (controller.flickManager.flickVideoManager == null &&
            !controller.flickManager.flickVideoManager!.isVideoInitialized ==
                true) {
          return Container(
            width: double.infinity,
            height: 200, // Placeholder height
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.video_camera_back_outlined,
                size: 60,
                color: context.theme.colorScheme.secondary,
              ),
            ),
          );
        }

        return AspectRatio(
          aspectRatio: controller.flickManager.flickVideoManager
                  ?.videoPlayerController?.value.aspectRatio ??
              16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlickVideoPlayer(
                flickManager: controller.flickManager,
                preferredDeviceOrientationFullscreen: [
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]),
          ),
        );
      },
    );
  }
}

class FileVideoController extends GetxController {
  late final FlickManager flickManager;
  final String videoPath;

  /// Constructor with the video path.
  FileVideoController(this.videoPath);

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  /// Initializes the media player and video controller.
  Future<void> _initializePlayer() async {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(videoPath)),
      autoPlay: false,
    );
  }

  @override
  void onClose() {
    flickManager.dispose();
    super.onClose();
  }
}
