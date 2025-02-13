import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:socialapp/core/formatNumber/format_number.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/pages/profile_screen.dart';
import 'package:socialapp/features/notifications/pages/notifications_screen.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/posts/pages/add_post_screen.dart';
import 'package:socialapp/features/posts/pages/home_screen.dart';
import 'package:socialapp/features/posts/pages/videos_screen.dart';
import 'package:socialapp/features/search/pages/search_screen.dart';

class MainLayout extends GetView<MainLayoutController> {
  static const String routeName = "/Main";
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.find<AuthController>();
    List<Widget> screens = [
      const HomeScreen(),
      SearchScreen(),
      VideosScreen(),
      ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        extendBody: true,
        appBar: controller.currentScreen.value != 0
            ? null
            : AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/social.png",
                      width: 35,
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                // title: Text(
                //   "title".tr,
                //   style: TextStyle(
                //     color: context.theme.colorScheme.primary,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 30,
                //   ),
                // ),
                actions: [
                  // if ((authController.user.value?.freePlan == true ||
                  //         authController.user.value?.freePlan == null) &&
                  //     (authController.user.value?.basicPlan == false ||
                  //         authController.user.value?.basicPlan == null) &&
                  //     (authController.user.value?.plusPlan == false ||
                  //         authController.user.value?.plusPlan == null)) ...[
                  //   IconButton(
                  //     onPressed: () {
                  //       Get.toNamed(SupportAppScreen.routeName);
                  //     },
                  //     icon: const Icon(Icons.support_outlined),
                  //   ),
                  // ],

                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.toNamed(NotificationsScreen.routeName);
                        },
                        icon: const Icon(Icons.favorite_border_rounded),
                      ),
                      if (controller.notificationsController.notReaded > 0)
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                              minWidth: 19,
                              minHeight: 19,
                            ),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              formatNumber(controller
                                  .notificationsController.notReaded
                                  .toInt()),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  // TESTING
                  // IconButton(
                  //   onPressed: () async {
                  //     // XFile? file = await ImagePicker()
                  //     //     .pickImage(source: ImageSource.gallery);
                  //     // if (file == null) {
                  //     //   print("error..........");
                  //     //   return;
                  //     // }
                  //     // final uniqueName = DateTime.now().second.toString();
                  //     // await Workmanager().registerOneOffTask(
                  //     //   uniqueName,
                  //     //   "fastTask",
                  //     //   // initialDelay: const Duration(seconds: 5),
                  //     //   constraints: Constraints(
                  //     //     networkType: NetworkType.connected,
                  //     //   ),
                  //     //   inputData: {
                  //     //     "file": file.path,
                  //     //   },
                  //     // );
                  //   },
                  //   icon: const Icon(Icons.telegram),
                  // ),
                  // END TESTING
                ],
              ),
        body: screens[controller.currentScreen.value],
        bottomNavigationBar: Obx(
          () => AnimatedBottomNavigationBar(
            backgroundColor: context.theme.colorScheme.tertiary,
            shadow: Shadow(
              color: context.theme.colorScheme.surface,
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
            icons: const [
              FontAwesome.house_solid,
              FontAwesome.magnifying_glass_solid,
              FontAwesome.tv_solid,
              // Icons.ondemand_video_rounded,
              // Icons.people_alt,
              FontAwesome.user_solid,
            ],
            iconSize: 20,
            activeColor: Theme.of(context).colorScheme.primary,
            // inactiveColor: Colors.grey,
            activeIndex: controller.currentScreen.value,
            onTap: (index) {
              controller.changeScreen(index);
            },
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AddPostScreen.routeName);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
