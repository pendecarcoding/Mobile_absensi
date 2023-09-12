import 'package:absensi/model/message/MessageModel.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../model/login/LoginModel.dart';
import '../../repository/login/LoginRepolpm.dart';

class LoginVM extends ChangeNotifier {
  final _myRepo = LoginRepolpm();

  ApiResponse<LoginModel> login = ApiResponse.loading();
  ApiResponse<MessageModel> message = ApiResponse.loading();

  void _setMain(ApiResponse<LoginModel> response) {
    print("$response");
    login = response;
    notifyListeners();
  }

  void _setMessage(ApiResponse<MessageModel> response) {
    print("$response");
    message = response;
    notifyListeners();
  }

  //Login Data
  Future<void> actlogin(String email, String password, String token) async {
    _myRepo.LoginPost(email, password, token)
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
        .then((value) => _setMessage(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMessage(ApiResponse.error(error.toString())));
  }

  //UPDATE SANDI
  Future<void> UpdateSandi(Map<String, String> data) async {
    _myRepo.Updatepassword(data)
        .then((value) => _setMessage(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMessage(ApiResponse.error(error.toString())));
  }
}
