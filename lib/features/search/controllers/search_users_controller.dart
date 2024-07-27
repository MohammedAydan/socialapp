import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socialapp/core/error/failure.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/features/search/services/repositories/search_users_repository.dart';

class SearchUsersController extends GetxController {
  final SearchUsersRepository searchUsersRepository;
  TextEditingController textEditingController = TextEditingController();
  RxList<UserModel> users = RxList<UserModel>();
  RxBool isLoading = false.obs;
  RxString error = "".obs;

  SearchUsersController(this.searchUsersRepository);

  Future<void> searchUsers(String usernameOrEmail) async {
    if (usernameOrEmail.isNotEmpty) {
      try {
        error("");
        isLoading(true);
        final res = await searchUsersRepository.searchUsers(usernameOrEmail);

        res.fold((l) {
          error(getMessageFromFailure(l));
        }, (r) {
          users.value.clear();
          users = r.obs;
        });
      } on Failure catch (e) {
        error(getMessageFromFailure(e));
      } finally {
        isLoading(false);
      }
    } else {
      users.value.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}
