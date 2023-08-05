import 'dart:ffi';

import 'package:absensi/model/message/MessageModel.dart';

import '../../data/remote/network/ApiEndPoints.dart';
import '../../data/remote/network/BaseApiService.dart';
import '../../data/remote/network/NetworkApiService.dart';
import '../../model/login/LoginModel.dart';
import 'LoginRepo.dart';

class LoginRepolpm implements LoginRepo {
  get http => null;
  BaseApiService _apiService = NetworkApiService();

  @override
  Future<LoginModel?> LoginPost(email, password) async {
    try {
      Map<String, String> data = {"username": email, "password": password};
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().Loginpost, data);
      //print("$response");
      final jsonData = LoginModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<LoginModel?> DetailAccount(id) async {
    try {
      Map<String, String> data = {"id": id};
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().getaccount, data);
      //print("$response");
      final jsonData = LoginModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
    throw UnimplementedError();
  }

  @override
  Future<MessageModel?> UpdateAccount(Map<String, String> array) async {
    try {
      Map<String, String> data = array;
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().updateaccount, data);
      //print("$response");
      final jsonData = MessageModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<MessageModel?> Updatepassword(Map<String, String> array) async {
    try {
      Map<String, String> data = array;
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().updatesandi, data);
      //print("$response");
      final jsonData = MessageModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
