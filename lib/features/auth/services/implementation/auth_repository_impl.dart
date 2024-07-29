import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialapp/core/error/exceptions.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/models/user_register_model.dart';
import 'package:socialapp/features/auth/services/repositories/auth_repository.dart';
import 'package:socialapp/main.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final GetStorage storage;

  AuthRepositoryImpl(this.networkInfo, this.storage);

  @override
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword(
      UserRegisterModel user) async {
    try {
      if (await _checkUsername(user.username)) {
        return Left(ServerFailure(error: "username_is_already_exists".tr));
      }

      final res = await supabase.auth.signUp(
        email: user.email,
        password: user.password,
      );

      if (res.user == null) {
        return Left(ServerFailure());
      }

      await supabase.from("users_data").insert({
        "user_id": res.user!.id,
        ...user.toMap(),
      });

      final userData = await _getUser();
      if (userData == null) {
        return Left(ServerFailure());
      }
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return Left(ServerFailure(error: "invalid_email_or_password".tr));
      }

      final userData = await _getUser();
      if (userData == null) {
        return Left(ServerFailure());
      }
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure(error: "invalid_email_or_password".tr));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final res = supabase.auth.currentSession;
      return Right(res != null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await supabase.auth.signOut();
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final userData = await _getUser();
      if (userData == null) {
        return Left(ServerFailure());
      }
      await saveNotificationUserId(userData.userId.toString());
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<UserModel?> _getUser() async {
    if ((await networkInfo.isConnected) == true) {
      try {
        final uid = supabase.auth.currentUser?.id;
        if (uid == null) {
          return null;
        }

        final res = await supabase
            .from('users_data')
            .select()
            .eq('user_id', uid)
            .single();

        if (res.isEmpty) {
          return null;
        }

        await storage.write("USER_DATA", res);
        return UserModel.fromJson(res);
      } catch (e) {
        return null;
      }
    } else {
      final localUser = storage.read("USER_DATA");
      return UserModel.fromJson(localUser);
    }
  }

  Future<bool> _checkUsername(String username) async {
    final res = await supabase
        .from('users_data')
        .select()
        .eq('username', username)
        .limit(1);

    return res.isNotEmpty;
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    try {
      await supabase.from("users_data").update({
        "first_name": user.firstName,
        "last_name": user.lastName,
        "phone": user.phone,
        "day": user.day,
        "month": user.month,
        "year": user.year,
        "location": user.location!.toJson(),
      }).eq("user_id", user.userId.toString());

      final userData = await _getUser();
      if (userData == null) {
        return Left(ServerFailure());
      }
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future saveNotificationUserId(String userId) async {
    try {
      // final notificationUserId = await getNotificationUserId();
      // if (notificationUserId == null) {
      //   return;
      // }

      await supabase.from("users_data").update({
        "notification_user_id": OneSignal.User.pushSubscription.id,
      }).eq("user_id", userId);

      OneSignal.User.pushSubscription.addObserver(
        (state) async {
          if (state.current.id!.isNotEmpty) {
            await supabase.from("users_data").update({
              "notification_user_id": state.current.id,
            }).eq("user_id", userId);
          }
        },
      );

      return;
    } catch (e) {
      return;
    }
  }

  Future<String?> getNotificationUserId() async {
    return await OneSignal.User.getOnesignalId();
  }

  @override
  Future<Either<Failure, String>> updateUserImage(
      XFile img, String? currenImageUrl) async {
    if (await networkInfo.isConnected) {
      try {
        final userId = supabase.auth.currentUser?.id;
        if (userId == null) {
          return Left(ServerFailure());
        }

        final imgPath = "$userId-${DateTime.now().toIso8601String()}.jpg";
        final storageResponse = await supabase.storage
            .from("usersImages")
            .upload(imgPath, File(img.path));

        final publicUrlResponse =
            supabase.storage.from("").getPublicUrl(storageResponse);

        await supabase.from("users_data").update({
          "image_url": publicUrlResponse,
        }).eq("user_id", userId);
        if (currenImageUrl != null && currenImageUrl.isNotEmpty) {
          await supabase.storage.from("media").remove(
            [currenImageUrl.split("media/").last],
          );
        }

        return Right(publicUrlResponse);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getFollowers({
    int? page = 1,
    int? limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userId = supabase.auth.currentUser?.id;
        if (userId == null) {
          return Left(ServerFailure());
        }
        final int offset = (page! - 1) * limit!;
        final response = await supabase
            .from("followers")
            .select("users_data!followers_follower_user_id_fkey1(*)")
            .eq("following_user_id", userId)
            .order("created_at", ascending: false)
            .limit(limit)
            .range(offset, offset + limit - 1);

        List<dynamic> uRes = response as List<dynamic>;
        List<UserModel> users =
            uRes.map((u) => UserModel.fromJson(u['users_data'])).toList();

        return Right(users);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getFollowings({
    int? page = 1,
    int? limit = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userId = supabase.auth.currentUser?.id;
        if (userId == null) {
          return Left(ServerFailure());
        }
        final int offset = (page! - 1) * limit!;
        final response = await supabase
            .from("followers")
            .select("users_data!followers_following_user_id_fkey1(*)")
            .eq("follower_user_id", userId)
            .order("created_at", ascending: false)
            .limit(limit)
            .range(offset, offset + limit - 1);

        List<dynamic> uRes = response as List<dynamic>;
        List<UserModel> users =
            uRes.map((u) => UserModel.fromJson(u['users_data'])).toList();

        return Right(users);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  //updateUserStatus
  @override
  Future<Either<Failure, Unit>> updateUserStatus(
    bool status, {
    String? uid,
  }) async {
    try {
      final userId = uid ?? supabase.auth.currentUser?.id;
      if (userId == null) {
        return Left(ServerFailure());
      }

      await supabase.from("users_data").update({
        "status": status,
      }).eq("user_id", userId);

      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
