import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';

abstract class SearchUsersRepository {
  Future<Either<Failure,List<UserModel>>> searchUsers(String usernameOrEmail);
}
