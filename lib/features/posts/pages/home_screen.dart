import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/show_posts.dart';
import 'package:socialapp/widgets/error_card.dart';
import 'package:socialapp/widgets/error_card_and_refresh_button.dart';
import 'package:socialapp/widgets/loadings/post_loading.dart';

import '../widgets/show_posts_and_ads.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/Home";
  final double? maxWidth;

  const HomeScreen({super.key, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostsController>();

    return Scaffold(
      body: Column(
        children: [
          ObxValue((v) {
            if (controller.error.value.isNotEmpty) {
              return Column(
                children: [
                  ErrorCard(error: controller.error.value),
                  const SizedBox(height: 10),
                ],
              );
            }
            return const SizedBox();
          }, controller.error),
          Expanded(
            child: Obx(() {
              if (controller.loadingPosts.value) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => const PostLoading(),
                );
              }
              if (controller.posts.isEmpty && !controller.loadingPosts.value) {
                return ErrorCardAndRefreshButton(
                  method: controller.getInitPosts,
                  message: "no_posts_found".tr,
                );
              }

              // if (controller.error.value.isNotEmpty) {
              //   return Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       InkWell(
              //         onTap: () => controller.getInitPosts(),
              //         child: Container(
              //           width: double.infinity,
              //           padding: const EdgeInsets.all(10),
              //           margin: const EdgeInsets.all(10),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             color: Colors.red.withOpacity(0.1),
              //           ),
              //           child: Text(
              //             controller.error.value,
              //             style: const TextStyle(
              //               color: Colors.red,
              //               fontSize: 16,
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 10),
              //     ],
              //   );
              // }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshPosts();
                },
                child: (controller.authController.user.value?.basicPlan ==
                            true ||
                        controller.authController.user.value?.plusPlan == true)
                    ? ShowPosts(controller: controller, maxWidth: maxWidth)
                    : ShowPostsAndAds(
                        controller: controller,
                        maxWidth: maxWidth,
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
