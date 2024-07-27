import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:socialapp/core/imagePicker/image_picker.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/controllers/followers_controller.dart';
import 'package:socialapp/features/auth/controllers/followings_controller.dart';
import 'package:socialapp/features/auth/controllers/profile_controller.dart';
import 'package:socialapp/features/auth/services/implementation/auth_repository_impl.dart';
import 'package:socialapp/features/auth/services/repositories/auth_repository.dart';
import 'package:socialapp/features/notifications/controllers/notifications_controller.dart';
import 'package:socialapp/features/notifications/services/implementation/notifications_repository_impl.dart';
import 'package:socialapp/features/notifications/services/repositories/notifications_repository.dart';
import 'package:socialapp/features/posts/controllers/likes_controller.dart';
import 'package:socialapp/features/posts/controllers/main_layout_controller.dart';
import 'package:socialapp/features/posts/controllers/posts_controller.dart';
import 'package:socialapp/features/posts/controllers/shareings_controller.dart';
import 'package:socialapp/features/posts/controllers/videos_posts_controller.dart';
import 'package:socialapp/features/posts/services/implementation/comments_repository_impl.dart';
import 'package:socialapp/features/posts/services/implementation/manage_posts_repository_impl.dart';
import 'package:socialapp/features/posts/services/implementation/post_repository_impl.dart';
import 'package:socialapp/features/posts/services/repositories/comments_repository.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/features/posts/services/repositories/post_repository.dart';
import 'package:socialapp/features/search/controllers/search_users_controller.dart';
import 'package:socialapp/features/search/services/implementation/search_users_repository_impl.dart';
import 'package:socialapp/features/search/services/repositories/search_users_repository.dart';
import 'package:socialapp/features/settings/controllers/settings_controller.dart';
import 'package:socialapp/features/settings/services/implementation/settings_repository_impl.dart';
import 'package:socialapp/features/settings/services/repositories/settings_repository.dart';
import 'package:socialapp/features/user_profile/services/implementation/user_profile_repository_impl.dart';
import 'package:socialapp/features/user_profile/services/repositories/user_profile_repository.dart';
import 'package:socialapp/onesignal_notification.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Flutter Downloader
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  // External
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => GetStorage());
  sl.registerLazySingleton(() => ImagePicker());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => OneSignalNotificationsP());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ManagePostsRepository>(() => ManagePostsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<UserProfileRepository>(() => UserProfileRepositoryImpl(sl()));
  sl.registerLazySingleton<SearchUsersRepository>(() => SearchUsersRepositoryImpl(sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<CommentsRepository>(() => CommentsRepositoryImpl(sl()));
  sl.registerLazySingleton<ImagePickerRepository>(() => ImagePickerRepositoryImpl(sl()));

  // Controllers
  Get.put(AuthController(sl(), sl()));
  Get.put(NotificationsController(sl()));
  Get.put(MainLayoutController(Get.find()));

  Get.lazyPut(() => ProfileController(Get.find(), sl(), sl()));
  Get.lazyPut(() => PostsController(sl(), sl(), Get.find()));
  Get.lazyPut(() => VideosPostsController(sl(), Get.find()));
  Get.lazyPut(() => SearchUsersController(sl()));
  Get.lazyPut(() => SettingsController(sl(), Get.find<AuthController>()));
  Get.lazyPut(() => FollowersController(sl()), fenix: true);
  Get.lazyPut(() => FollowingsController(sl()), fenix: true);
  Get.lazyPut(() => LikesController(sl()), fenix: true);
  Get.lazyPut(() => ShareingsController(sl()), fenix: true);
}  