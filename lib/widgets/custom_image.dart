import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.url,
    this.width,
  });

  final String url;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final containerWidth = width ?? constraints.maxWidth;
            return Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(13),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  width: containerWidth,
                ),
              ),
            );
          },
        );
      },
      placeholder: (context, url) => Container(
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
