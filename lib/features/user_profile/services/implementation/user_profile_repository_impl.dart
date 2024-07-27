import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/models/follower_model.dart';
import 'package:socialapp/features/user_profile/services/repositories/user_profile_repository.dart';
import 'package:socialapp/main.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final NetworkInfo networkInfo;

  UserProfileRepositoryImpl(this.networkInfo);

  @override
  Future<Either<Failure, FollowerModel?>> checkRequestToFollowYou(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        final res = await supabase
            .from("followers")
            .select()
            .eq("following_user_id", myId)
            .eq("follower_user_id", userId);

        if (res.isEmpty) {
          return const Right(null);
        }

        final followR = FollowerModel.fromJson(res.first);
        return Right(followR);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, FollowerModel?>> isFollowOrFollowRequest(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        final res = await supabase
            .from("followers")
            .select()
            .eq("following_user_id", myId)
            .eq("follower_user_id", userId);

        if (res.isEmpty) {
          return const Right(null);
        }

        final followR = FollowerModel.fromJson(res.first);
        return Right(followR);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> acceptFollowRequest(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        await supabase
            .from("followers")
            .update({"status": true})
            .eq("following_user_id", myId)
            .eq("follower_user_id", userId);

        await supabase.rpc("increment_follower_and_following_count", params: {
          "p_user_id": myId,
          "p_my_id": userId,
        });
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> addFollow(String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        await supabase.from("followers").insert({
          "follower_user_id": myId,
          "following_user_id": userId,
          "status": true,
        });

        await supabase.rpc("increment_follower_and_following_count", params: {
          "p_user_id": userId,
          "p_my_id": myId,
        });

        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> addFollowRequest(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        await supabase.from("followers").insert({
          "follower_user_id": myId,
          "following_user_id": userId,
          "status": false,
        });
        await supabase.rpc("increment_follower_and_following_count", params: {
          "p_user_id": userId,
          "p_my_id": myId,
        });
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> removeFollowOrFollowRequest(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        await supabase
            .from("followers")
            .delete()
            .eq("follower_user_id", myId)
            .eq("following_user_id", userId);

        await supabase.rpc("decrement_follower_and_following_count", params: {
          "p_user_id": userId,
          "p_my_id": myId,
        });
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> rejectFollowRequest(
      String userId, String myId) async {
    return await _checkIsConnected(() async {
      try {
        await supabase
            .from("followers")
            .delete()
            .eq("following_user_id", myId)
            .eq("follower_user_id", userId);

        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    return await _checkIsConnected(() async {
      try {
        final res = await supabase
            .from("users_data")
            .select()
            .eq("user_id", userId)
            .single();
        final user = UserModel.fromJson(res);
        return Right(user);
      } catch (e) {
        return Left(ServerFailure());
      }
    });
  }

  Future<Either<Failure, T>> _checkIsConnected<T>(
      Future<Either<Failure, T>> Function() fun) async {
    if (await networkInfo.isConnected) {
      return await fun();
    } else {
      return Left(OfflineFailure());
    }
  }
}


// add policie for update
// get posts