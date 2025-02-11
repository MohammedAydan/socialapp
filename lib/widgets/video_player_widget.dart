import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

// class VideoPlayerWidget extends StatelessWidget {
//   const VideoPlayerWidget({
//     super.key,
//     required this.url,
//     required this.controller,
//   });

//   final Uri url;
//   final PostController controller;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Obx(
//         () {
//           if (controller.videoPlayerController.value == null) {
//             return Container(
//               width: double.infinity,
//               height: 200, // Placeholder height
//               decoration: BoxDecoration(
//                 color: context.theme.colorScheme.surface,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: Icon(
//                   Icons.video_camera_back_outlined,
//                   size: 60,
//                   color: context.theme.colorScheme.secondary,
//                 ),
//               ),
//             );
//           }
//           return AspectRatio(
//             aspectRatio: (controller.videoPlayerController.value?.width ?? 16) /
//                 (controller.videoPlayerController.value?.height ?? 9)
//                     .toDouble(),
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: context.theme.colorScheme.surface,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Video(
//                   controller: controller.videoPlayerController.value!,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// Make sure to add following packages to pubspec.yaml:
// * media_kit
// * media_kit_video
// * media_kit_libs_video

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.url,
    required this.controller,
  });

  final String url;
  final PostController controller;

  @override
  State<VideoPlayerWidget> createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      ),
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        child: FlickVideoPlayer(flickManager: flickManager),
      ),
    );
  }
}
