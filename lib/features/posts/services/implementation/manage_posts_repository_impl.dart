import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socialapp/core/UploadMedia/upload_media.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/core/network/network_info.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/posts/models/post_model.dart';
import 'package:socialapp/features/posts/services/repositories/manage_posts_repository.dart';
import 'package:socialapp/main.dart';

class ManagePostsRepositoryImpl implements ManagePostsRepository {
  final GetStorage storage;
  final NetworkInfo networkInfo;
  final UploadMedia uploadMedia;

  ManagePostsRepositoryImpl(this.storage, this.networkInfo, this.uploadMedia);

  @override
  Future<Either<Failure, PostModel>> addPost(PostModel post) async {
    try {
      final res = await supabase.rpc(
        "insert_post_and_increment_count",
        params: {
          "p_user_id": post.userId,
          "p_sharing_post_id": post.sharingPostId,
          "p_title": post.title,
          "p_body": post.body,
          "p_media_type": post.mediaType,
          "p_media_url": post.mediaUrl,
          "p_media_name": post.mediaName,
          "p_media_size": post.mediaSize,
          "p_likes_count": post.likesCount,
          "p_comments_count": post.commentsCount,
          "p_sharings_count": post.sharingsCount,
          "p_views_count": post.viewsCount,
          "p_public": post.public,
          "p_tags": post.tags,
        },
      );

      if (post.sharingPostId != null) {
        await supabase.rpc("increment_sharings_count", params: {
          "p_post_id": post.sharingPostId,
          "p_user_id": supabase.auth.currentUser?.id,
        });
      }

      if (res == null) {
        throw Exception("Failed to upsert post");
      }

      print(".....................");
      print(res);

      final updatedPost = PostModel.fromJson(res as Map<String, dynamic>);
      return Right(updatedPost);
    } catch (e) {
      print("..............................................error");
      print(e);
      print("Error adding post: $e");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(PostModel post) async {
    if (await networkInfo.isConnected) {
      try {
        await supabase.from("posts").delete().eq("id", post.postId!);
        if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) {
          if (post.mediaUrl!.contains("cloudinary")) {
            // Cloudinary Storage
            await uploadMedia.deleteImageFromCloudinary(post.mediaUrl!);
          } else {
            // Supabase Storage
            await supabase.storage.from("media").remove(
              [post.mediaUrl!.split("media/").last],
            );
          }
        }
        await supabase.rpc("decrement_posts_count", params: {
          "p_user_id": post.userId,
        });
        if (post.sharingPostId != null) {
          await supabase.rpc("decrement_sharings_count", params: {
            "p_post_id": post.sharingPostId,
            "p_user_id": supabase.auth.currentUser?.id,
          });
        }

        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPost(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await supabase.rpc("getsinglepostforuser", params: {
          "p_user_id": supabase.auth.currentUser?.id,
          "p_post_id": id,
        });

        storage.write("POST_$id-SINGLE_POST", res[0]);
        final post = PostModel.fromJson(res[0]);
        return Right(post);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final res = storage.read("POST_$id-SINGLE_POST");
      if (res == null) {
        return Left(OfflineFailure());
      }
      print("........................RES---ERROR");
      print(res);
      final post = PostModel.fromJson(res);
      return Right(post);
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPostsSuggested({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final int offset = (page - 1) * limit;

        // new function "get_latest_posts_fun"
        final res = await supabase.rpc("get_latest_posts_fun", params: {
          "p_user_id": supabase.auth.currentUser?.id,
          "p_limit": limit,
          "p_offset": offset,
        });

        // final res = await supabase.rpc("getlatestposts", params: {
        //   "p_user_id": supabase.auth.currentUser?.id,
        //   "p_limit": limit,
        //   "p_offset": offset,
        // });

        await storage.write("$page-${limit}_POSTS_KEY", res);

        List<PostModel> posts = (res as List)
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(posts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final res = await storage.read("$page-${limit}_POSTS_KEY");
      List<PostModel> posts = (res as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(posts);
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final int offset = (page - 1) * limit;

        final res = await supabase.rpc("getlatestposts", params: {
          "p_user_id": supabase.auth.currentUser?.id,
          "p_limit": limit,
          "p_offset": offset,
        });

        await storage.write("$page-${limit}_POSTS_KEY", res);

        List<PostModel> posts = (res as List)
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(posts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final res = await storage.read("$page-${limit}_POSTS_KEY");
      List<PostModel> posts = (res as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(posts);
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPostsByMediaType({
    int page = 1,
    int limit = 10,
    String? mediaType = "video",
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final int offset = (page - 1) * limit;

        final res = await supabase.rpc("getlatestpostsbymediatype", params: {
          "p_user_id": supabase.auth.currentUser?.id,
          "p_limit": limit,
          "p_offset": offset,
          "p_media_type": mediaType,
        });

        await storage.write("$page-${limit}_POSTS_KEY_$mediaType", res);

        List<PostModel> posts = (res as List)
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(posts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final res = await storage.read("$page-${limit}_POSTS_KEY__$mediaType");
      List<PostModel> posts = (res as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(posts);
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPostsByUserId(
    String id, {
    bool isPublic = true,
    bool all = false,
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final int offset = (page - 1) * limit;

        final res = await supabase.rpc("getlatestpostsforuser", params: {
          "p_user_id": id,
          "p_limit": limit,
          "p_offset": offset,
          "p_is_public": isPublic,
          "p_all": all,
        });

        await storage.write("$page-${limit}_${id}_POSTS_KEY", res);

        List<PostModel> posts = (res as List).map((json) {
          return PostModel.fromJson(json);
        }).toList();

        return Right(posts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      final res = await storage.read("$page-${limit}_${id}_POSTS_KEY");
      if (res == null) {
        return Left(OfflineFailure());
      }
      List<PostModel> posts = (res as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(posts);
    }
  }

  @override
  Future<Either<Failure, PostModel>> updatePost(PostModel post) async {
    if ((await networkInfo.isConnected) == true) {
      try {
        final res = await supabase
            .from("posts")
            .update(post.toJson())
            .eq("id", post.postId.toString());
        final fpost = PostModel.fromJson(res);
        return Right(fpost);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getLikes(
    int postId, {
    int page = 1,
    int limit = 20,
  }) async {
    if ((await networkInfo.isConnected) == true) {
      try {
        final uid = supabase.auth.currentUser?.id;
        final offset = (page - 1) * limit;
        final res = await supabase
            .from("likes")
            .select("users_data(*)")
            .eq("post_id", postId)
            // .eq("user_id", uid!)
            .order("created_at", ascending: false)
            .range(offset, offset + limit - 1);

        final fposts =
            res.map((json) => UserModel.fromJson(json["users_data"])).toList();

        return Right(fposts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getShareings(
    int postId, {
    int page = 1,
    int limit = 20,
  }) async {
    if ((await networkInfo.isConnected) == true) {
      try {
        final uid = supabase.auth.currentUser?.id;
        final offset = (page - 1) * limit;
        final res = await supabase
            .from("sharings")
            .select("users_data(*)")
            .eq("post_id", postId)
            // .eq("user_id", uid!)
            .order("created_at", ascending: false)
            .range(offset, offset + limit - 1);

        final fposts =
            res.map((json) => UserModel.fromJson(json["users_data"])).toList();

        return Right(fposts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
