import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/models/follower_model.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserModel>> getUser(String userId);
  Future<Either<Failure, FollowerModel?>> checkRequestToFollowYou(
    String userId,
    String myId,
  );
  Future<Either<Failure, FollowerModel?>> isFollowOrFollowRequest(
    String userId,
    String myId,
  );
  Future<Either<Failure, Unit>> addFollow(String userId, String myId);
  Future<Either<Failure, Unit>> removeFollowOrFollowRequest(
    String userId,
    String myId,
  );
  Future<Either<Failure, Unit>> addFollowRequest(String userId, String myId);
  Future<Either<Failure, Unit>> rejectFollowRequest(String userId, String myId);
  Future<Either<Failure, Unit>> acceptFollowRequest(String userId, String myId);
}
