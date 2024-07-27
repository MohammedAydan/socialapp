import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({super.key});

  @override
  Widget build(BuildContext context) {
    String url = (Get.arguments as String);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: context.theme.colorScheme.secondary,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (context, imageProvider) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: const BoxDecoration(
                      // color: context.theme.colorScheme.surface,
                      ),
                  child: PhotoView(
                    imageProvider: imageProvider,
                  ),
                );
              },
            );
          },
          placeholder: (context, url) => Container(
            height: 230,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            height: 230,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(),
            child: const Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      //
    );
  }
}
