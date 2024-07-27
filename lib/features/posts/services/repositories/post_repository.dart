import 'package:dartz/dartz.dart';
import 'package:socialapp/core/error/failure.dart';

abstract class PostRepository {
  Future<Either<Failure, Unit>> addLike(String postId);
  Future<Either<Failure, Unit>> removeLike(String postId);
}
