import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.url,
    this.radius,
  });
  final String url;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(200),
        ),
        child: CircleAvatar(
          backgroundColor: context.theme.colorScheme.surface,
          radius: radius ?? 100,
          backgroundImage: imageProvider,
        ),
      ),
      placeholder: (context, url) => Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(200),
        ),
        child: CircleAvatar(
          backgroundColor: context.theme.colorScheme.surface,
          radius: radius ?? 100,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.theme.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(200),
        ),
        child: CircleAvatar(
          backgroundColor: context.theme.colorScheme.surface,
          radius: radius ?? 100,
          child: const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}
