import 'package:get/get.dart';
import 'package:socialapp/features/notifications/controllers/notifications_controller.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';

class MainLayoutController extends GetxController {
  final NotificationsController notificationsController;
  RxInt currentScreen = RxInt(0);

  MainLayoutController(this.notificationsController);

  void changeScreen(int index) {
    if (index == 0 && currentScreen.value == index) {
      scrollOnTopAndRefresh();
    }
    currentScreen.value = index;
  }

  void scrollOnTopAndRefresh() async {
    try {
      // Attempt to find the PostsController
      final postsController = Get.find<PostsController>();
      // Call the scrollOnTopAndRefresh method
      postsController.scrollOnTopAndRefresh();
    } catch (e) {
      // Handle the error (optional: log the error or notify the user)
      print(
          'Error finding PostsController or calling scrollOnTopAndRefresh: $e');
    }
  }
}
