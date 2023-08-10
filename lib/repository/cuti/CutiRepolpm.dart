import 'dart:io';

import 'package:absensi/model/message/ResponseModel.dart';

import '../../data/remote/network/ApiEndPoints.dart';
import '../../data/remote/network/BaseApiService.dart';
import '../../data/remote/network/NetworkApiService.dart';
import '../../model/absensi/CutiModel.dart';
import '../../model/absensi/DinasModel.dart';
import '../../model/message/MessageModel.dart';
import 'CutiRepo.dart';

class CutiRepolpm implements CutiRepo {
  get http => null;
  BaseApiService _apiService = NetworkApiService();
  @override
  Future<CutiModel?> getcuti(String id, String id_instansi) async {
    try {
      Map<String, String> data = {
        "id": id,
        "id_instansi": id_instansi,
      };
      dynamic response = await _apiService.getResponse(
        ApiEndPoints().getcuti + "/" + id + "/" + id_instansi,
      );
      // print("$response");
      final jsonData = CutiModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<DinasModel?> getdinas(String id, String id_instansi) async {
    try {
      Map<String, String> data = {
        "id": id,
        "id_instansi": id_instansi,
      };
      dynamic response = await _apiService.getResponse(
        ApiEndPoints().getdinas + "/" + id + "/" + id_instansi,
      );
      // print("$response");
      final jsonData = DinasModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel?> adddinas(
      File file, Map<String, dynamic> requestData) async {
    try {
      dynamic response = await _apiService.postResponseMultipart(
          ApiEndPoints().adddinas, file, requestData);
      //print("$response");
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel?> addcuti(
      File file, Map<String, dynamic> requestData) async {
    try {
      dynamic response = await _apiService.postResponseMultipart(
          ApiEndPoints().addcuti, file, requestData);
      //print("$response");
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel?> updatecutiuseimage(
      File file, Map<String, dynamic> requestData) async {
    try {
      dynamic response = await _apiService.postResponseMultipart(
          ApiEndPoints().updatecutiimage, file, requestData);
      //print("$response");
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel> deletecuti(String id) async {
    try {
      dynamic response = await _apiService.getResponse(
        ApiEndPoints().deletecuti + "/" + id,
      );
      // print("$response");
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel> deletedinas(String id) async {
    try {
      dynamic response = await _apiService.getResponse(
        ApiEndPoints().deletedinas + "/" + id,
      );
      // print("$response");
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<ResponseModel> updatecutinoimage(
      Map<String, dynamic> requestData) async {
    try {
      dynamic response = await _apiService.postResponse(
          ApiEndPoints().updatecutinoimage, requestData);
      final jsonData = ResponseModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }
}
