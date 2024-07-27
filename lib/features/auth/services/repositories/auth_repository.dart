import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/auth/models/user_register_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword(
      UserRegisterModel user);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, UserModel>> getUser();
  Future<Either<Failure, UserModel>> updateUser(UserModel user);
  Future<Either<Failure, String>> updateUserImage(XFile img,String? currenImageUrl);
  Future<Either<Failure, List<UserModel>>> getFollowers({
    int? page = 1,
    int? limit = 20,
  });
  Future<Either<Failure, List<UserModel>>> getFollowings({
    int? page = 1,
    int? limit = 20,
  });
  //updateUserStatus
  Future<Either<Failure, Unit>> updateUserStatus(bool status);
}
