import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/widgets/show_posts.dart';
import 'package:socialapp/features/posts/widgets/show_posts_Suggested_and_ads.dart';
import 'package:socialapp/features/posts/widgets/show_posts_suggested.dart';
import 'package:socialapp/widgets/error_card.dart';
import '../widgets/show_posts_and_ads.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/Home";
  final double? maxWidth;

  const HomeScreen({super.key, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostsController>();

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        initialIndex: controller.getInitalPage(),
        child: Column(
          children: [
            Obx(
              () => Visibility(
                visible: controller.isVisibility.value,
                child: Container(
                  color: Get.theme.appBarTheme.backgroundColor,
                  child: TabBar(
                    unselectedLabelColor:
                        Get.theme.colorScheme.primary.withOpacity(0.5),
                    labelColor: Get.theme.colorScheme.primary,
                    indicatorColor: Get.theme.colorScheme.primary,
                    indicatorWeight: 2.0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    onTap: controller.setInitalPage,
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.home_rounded),
                        text: "home".tr
                      ),
                      Tab(
                        icon: const Icon(Icons.sailing_rounded),
                        text: "suggested".tr,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.error.value.isNotEmpty) {
                return Column(
                  children: [
                    ErrorCard(error: controller.error.value),
                    const SizedBox(height: 10),
                  ],
                );
              }
              return const SizedBox();
            }),
            Expanded(
              child: Obx(() {
                return TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.refreshPosts();
                      },
                      child: (controller.authController.user.value?.basicPlan ==
                                  true ||
                              controller.authController.user.value?.plusPlan ==
                                  true)
                          ? ShowPosts(
                              controller: controller,
                              maxWidth: maxWidth,
                            )
                          : ShowPostsAndAds(
                              controller: controller,
                              maxWidth: maxWidth,
                            ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await controller.refreshPostsSuggested();
                      },
                      child: (controller.authController.user.value?.basicPlan ==
                                  true ||
                              controller.authController.user.value?.plusPlan ==
                                  true)
                          ? ShowPostsSuggested(
                              controller: controller,
                              maxWidth: maxWidth,
                            )
                          : ShowPostsSuggestedAndAds(
                              controller: controller,
                              maxWidth: maxWidth,
                            ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
