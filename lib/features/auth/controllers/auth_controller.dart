import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/models/user_register_model.dart';
import 'package:socialapp/features/auth/pages/login_screen.dart';
import 'package:socialapp/features/auth/pages/signout_screen.dart';
import 'package:socialapp/features/auth/services/repositories/auth_repository.dart';
import 'package:socialapp/features/posts/layouts/main_layout.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  Rxn<UserModel> user = Rxn<UserModel>();
  final AuthRepository authRepository;
  final ManagePostsRepository postRepository;
  RxBool termsAndConditions = true.obs;
  RxString error = "".obs;
  RxString fName = "".obs;
  RxString lName = "".obs;
  RxString username = "".obs;
  RxString email = "".obs;
  RxString day = "".obs;
  RxString month = "".obs;
  RxString year = "".obs;
  RxString pass = "".obs;
  RxString repass = "".obs;

  AuthController(this.authRepository, this.postRepository);

  Future<void> login(String email, String password) async {
    try {
      error("");
      showLoading();
      final res =
          await authRepository.signInWithEmailAndPassword(email, password);
      res.fold(
        (l) {
          Get.back();
          error("invalid_email_or_password".tr);
        },
        (r) {
          user.value = r;
          Get.back();
          _updateUserStatus(true);
          Get.offAllNamed(MainLayout.routeName);
        },
      );
    } catch (e) {
      Get.back();
      error("server_error".tr);
    }
  }

  Future<void> register() async {
    if (pass.value != repass.value) {
      error("passwords_do_not_match".tr);
      return;
    }
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      error("date_fields_cannot_be_empty".tr);
      return;
    }
    try {
      error("");
      showLoading();
      final res = await authRepository.registerWithEmailAndPassword(
        UserRegisterModel(
          fName: fName.value,
          lName: lName.value,
          username: username.value,
          email: email.value,
          day: int.parse(day.value),
          month: int.parse(month.value),
          year: int.parse(year.value),
          password: pass.value,
          rePassword: repass.value,
        ),
      );
      res.fold(
        (l) {
          Get.back();
          error("invalid_data".tr);
        },
        (r) {
          user.value = r;
          Get.back();
          _updateUserStatus(true);
          Get.offAllNamed(MainLayout.routeName);
        },
      );
    } catch (e) {
      Get.back();
      error("server_error".tr);
    }
  }

  Future<void> signOut() async {
    try {
      error("");
      showLoading();
      final res = await authRepository.signOut();
      if (res.isRight()) {
        Get.back();
          _updateUserStatus(false);
        Get.offAllNamed(SignoutScreen.routeName);
      } else {
        Get.back();
        error("error_signOut".tr);
      }
    } catch (e) {
      Get.back();
      error("server_error".tr);
    }
  }

  Future<void> init() async {
    try {
      supabase.auth.startAutoRefresh();
      final isSignedInResult = await authRepository.isSignedIn();
      isSignedInResult.fold(
        (failure) => _navigateToLoginScreen(),
        (isSignedIn) async {
          if (isSignedIn) {
            final userResult = await _fetchUser();
            userResult.fold(
              (failure) => _navigateToLoginScreen(),
              (fetchedUser) {
                _setUser(fetchedUser);
                Get.offAllNamed(MainLayout.routeName);
              },
            );
          } else {
            _navigateToLoginScreen();
          }
        },
      );
    } catch (e) {
      error(e.toString());
    }
  }

  Future<Either<Failure, UserModel>> _fetchUser() async {
    try {
      return await authRepository.getUser();
    } catch (e) {
      rethrow;
    }
  }

  void _setUser(UserModel fetchedUser) {
    user.value = fetchedUser;
  }

  void _navigateToLoginScreen() {
    Get.offAllNamed(LoginScreen.routeName);
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      error("");
      showLoading();
      final res = await authRepository.updateUser(userModel);
      await _fetchUser();
      res.fold(
        (l) {
          Get.back();
          error(getMessageFromFailure(l));
        },
        (r) {
          user.value = r;
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      Get.back();
      error("server_error".tr);
    }
  }

  Future<bool> sendOTP(String email) async {
    if (email.isEmpty) {
      error("email_is_required_to_send_OTP".tr);
      return false;
    }
    try {
      error("");
      showLoading();
      await supabase.auth.resetPasswordForEmail(email);
      return true;
    } on AuthException catch (e) {
      error(e.message.toString());
      return false;
    } finally {
      Get.back();
    }
  }

  Future<bool> verifyOTP(String email, String token) async {
    if (email.isEmpty || token.isEmpty) {
      error("email_and_token_are_required_to_verify_OTP".tr);
      return false;
    }
    try {
      error("");
      showLoading();
      await supabase.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: token,
      );
      return true;
    } on AuthException catch (e) {
      error(e.message.toString());
      return false;
    } finally {
      Get.back();
    }
  }

  Future<bool> changePassword(String password, String rePassword) async {
    if (password != rePassword) {
      error("passwords_do_not_match".tr);
      return false;
    }
    try {
      error("");
      showLoading();
      await supabase.auth.updateUser(UserAttributes(password: password));
      final finalUser = await _fetchUser();
      finalUser.fold(
        (l) {
          Get.offAllNamed(LoginScreen.routeName);
          Get.back();
        },
        (r) {
          user(r);
          Get.back();
          Get.offAllNamed(MainLayout.routeName);
        },
      );
      return true;
    } on AuthException catch (e) {
      error(e.message.toString().tr);
      Get.back();
      return false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    init();
  }

  @override
  void onInit() {
    super.onInit();
    AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (supabase.auth.currentUser != null) {
          bool isResumed = state == AppLifecycleState.resumed;
          _updateUserStatus(isResumed);
        }
      },
    );
  }

  void _updateUserStatus(bool isOnline) {
    // Use Future.microtask for non-blocking execution
    Future.microtask(() async {
      try {
        await authRepository.updateUserStatus(isOnline);
      } catch (e) {
        print("Error updating user status: $e");
      }
    });
  }
}

