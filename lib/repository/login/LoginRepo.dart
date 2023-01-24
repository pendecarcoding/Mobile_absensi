import '../../model/login/LoginModel.dart';

class LoginRepo {
  Future<LoginModel?> LoginPost(String email, String password) async {}
  Future<LoginModel?> DetailAccount(String id) async {}
  Future<LoginModel?> UpdateAccount(Map<String, String> array) async {}
}
