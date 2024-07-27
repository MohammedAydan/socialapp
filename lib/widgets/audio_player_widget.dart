import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/post_controller.dart';
import 'package:voice_message_package/voice_message_package.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({
    super.key,
    required this.url,
    required this.controller,
  });

  final Uri url;
  final PostController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      width: double.infinity,
      child: Obx(() {
        if (controller.voiceController.value != null) {
          return VoiceMessageView(
            circlesColor: context.theme.colorScheme.primary,
            // backgroundColor: Colors.black,
            activeSliderColor: context.theme.colorScheme.primary,
            backgroundColor: context.theme.colorScheme.tertiary,

            controller: controller.voiceController.value!,
          );
        } else {
          return Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
          );
        }
      }),
    );
  }
}
