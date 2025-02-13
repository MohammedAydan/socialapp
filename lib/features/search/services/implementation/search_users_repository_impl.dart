import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/search/services/repositories/search_users_repository.dart';
import 'package:socialapp/main.dart';

class SearchUsersRepositoryImpl implements SearchUsersRepository {
  final NetworkInfo networkInfo;

  SearchUsersRepositoryImpl(this.networkInfo);

  @override
  Future<Either<Failure, List<UserModel>>> searchUsers(
      String usernameOrEmail) async {
    try {
      if ((await networkInfo.isConnected) == true) {
        final finalRes = await supabase
            .from("users_data")
            .select()
            // .ilike("first_name", "%$usernameOrEmail%")
            // .ilike("last_name", "%$usernameOrEmail%")
            .ilike("username", "%$usernameOrEmail%")
            .ilike("email", "%$usernameOrEmail%")
            .not("user_id", "eq", supabase.auth.currentUser?.id)
            .limit(10);

        if (finalRes.isEmpty) {
          return Left(NotFoundFailure());
        }

        List<UserModel> users = finalRes
            .map(
              (u) => UserModel.fromJson(u),
            )
            .toList();

        return Right(users);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
