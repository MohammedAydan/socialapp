import 'package:get/get.dart';
import 'package:socialapp/features/auth/pages/change_password_screen.dart';
import 'package:socialapp/features/auth/pages/edit_profile_screen.dart';
import 'package:socialapp/features/auth/pages/forgot_password_screen.dart';
import 'package:socialapp/features/auth/pages/login_screen.dart';
import 'package:socialapp/features/auth/pages/profile_screen.dart';
import 'package:socialapp/features/auth/pages/register_screen.dart';
import 'package:socialapp/features/auth/pages/show_followers_screen.dart';
import 'package:socialapp/features/auth/pages/show_followings_screen.dart';
import 'package:socialapp/features/auth/pages/signout_screen.dart';
import 'package:socialapp/features/auth/pages/splash_screen.dart';
import 'package:socialapp/features/auth/pages/verifide_email_screen.dart';
import 'package:socialapp/features/notifications/pages/notifications_screen.dart';
import 'package:socialapp/features/posts/layouts/main_layout.dart';
import 'package:socialapp/features/posts/pages/add_post_screen.dart';
import 'package:socialapp/features/posts/pages/home_screen.dart';
import 'package:socialapp/features/posts/pages/share_post_screen.dart';
import 'package:socialapp/features/posts/pages/show_likes_screen.dart';
import 'package:socialapp/features/posts/pages/show_post_screen.dart';
import 'package:socialapp/features/posts/pages/show_shareings_screen.dart';
import 'package:socialapp/features/posts/pages/support_app_screen.dart';
import 'package:socialapp/features/settings/pages/settings_screen.dart';
import 'package:socialapp/features/user_profile/pages/user_profile_screen.dart';

List<GetPage> getPages = [
  GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
  GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
  GetPage(name: RegisterScreen.routeName, page: () => const RegisterScreen()),
  GetPage(
    name: ForgotPasswordScreen.routeName,
    page: () => const ForgotPasswordScreen(),
  ),
  GetPage(
    name: VerifideEmailScreen.routeName,
    page: () => const VerifideEmailScreen(),
  ),
  GetPage(
    name: ChangePasswordScreen.routeName,
    page: () => const ChangePasswordScreen(),
  ),
  GetPage(
    name: ProfileScreen.routeName,
    page: () => ProfileScreen(),
  ),
  GetPage(
    name: EditProfileScreen.routeName,
    page: () => const EditProfileScreen(),
  ),
  GetPage(name: ProfileScreen.routeName, page: () => ProfileScreen()),
  GetPage(name: UserProfileScreen.routeName, page: () => UserProfileScreen()),
  GetPage(name: SettingsScreen.routeName, page: () => const SettingsScreen()),
  GetPage(name: ShowPostScreen.routeName, page: () => ShowPostScreen()),
  GetPage(name: AddPostScreen.routeName, page: () => const AddPostScreen()),
  GetPage(name: SharePostScreen.routeName, page: () => const SharePostScreen()),
  GetPage(name: HomeScreen.routeName, page: () => const HomeScreen()),
  GetPage(name: MainLayout.routeName, page: () => const MainLayout()),
  GetPage(
    name: NotificationsScreen.routeName,
    page: () => const NotificationsScreen(),
  ),
  GetPage(
    name: ShowFollowersScreen.routeName,
    page: () => const ShowFollowersScreen(),
  ),
  GetPage(
    name: ShowFollowingsScreen.routeName,
    page: () => const ShowFollowingsScreen(),
  ),
  GetPage(name: ShowLikesScreen.routeName, page: () => const ShowLikesScreen()),
  GetPage(
    name: ShowShareingsScreen.routeName,
    page: () => const ShowShareingsScreen(),
  ),
  GetPage(
    name: SupportAppScreen.routeName,
    page: () => const SupportAppScreen(),
  ),
  GetPage(
    name: SignoutScreen.routeName,
    page: () => const SignoutScreen(),
  ),
];
