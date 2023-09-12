import '../../model/login/LoginModel.dart';
import '../../model/message/MessageModel.dart';

class LoginRepo {
  Future<LoginModel?> LoginPost(
      String email, String password, String token) async {}
  Future<LoginModel?> DetailAccount(String id) async {}
  Future<MessageModel?> UpdateAccount(Map<String, String> array) async {}
  Future<MessageModel?> Updatepassword(Map<String, String> array) async {}
}
