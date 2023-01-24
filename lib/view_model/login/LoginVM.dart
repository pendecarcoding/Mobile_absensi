import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../model/login/LoginModel.dart';
import '../../repository/login/LoginRepolpm.dart';

class LoginVM extends ChangeNotifier {
  final _myRepo = LoginRepolpm();

  ApiResponse<LoginModel> login = ApiResponse.loading();

  void _setMain(ApiResponse<LoginModel> response) {
    print("$response");
    login = response;
    notifyListeners();
  }

  //Login Data
  Future<void> actlogin(String email, String password) async {
    _myRepo.LoginPost(email, password)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }

  //getaccount by login
  Future<void> DetailAccount(String id) async {
    _myRepo.DetailAccount(id)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }

  //Update Account
  Future<void> UpdateAccount(Map<String, String> data) async {
    _myRepo.UpdateAccount(data)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }
}
