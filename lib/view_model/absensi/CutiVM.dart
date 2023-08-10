import 'dart:io';

import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../model/absensi/DinasModel.dart';
import '../../model/message/ResponseModel.dart';
import '../../repository/absensi/AbsensiRepolpm.dart';
import '../../repository/cuti/CutiRepolpm.dart';

class CutiVM extends ChangeNotifier {
  final _myRepo = CutiRepolpm();
  ApiResponse<CutiModel> data = ApiResponse.loading();
  ApiResponse<DinasModel> datadinas = ApiResponse.loading();
  ApiResponse<ResponseModel> datacuti = ApiResponse.loading();

  void _setMain(ApiResponse<CutiModel> response) {
    print("$response");
    data = response;
    // print("$data");
    notifyListeners();
  }

  void _setMainDinas(ApiResponse<DinasModel> response) {
    print("$response");
    datadinas = response;
    // print("$data");
    notifyListeners();
  }

  void _setMainCuti(ApiResponse<ResponseModel> response) {
    print("$response");
    datacuti = response;
    // print("$data");
    notifyListeners();
  }

  //Cuti
  Future<void> getdatacuti(String id, String id_istansi) async {
    _myRepo
        .getcuti(id, id_istansi)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }

  Future<void> getdatadinas(String id, String id_istansi) async {
    _myRepo
        .getdinas(id, id_istansi)
        .then((value) => _setMainDinas(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainDinas(ApiResponse.error(error.toString())));
  }

  //add dinas
  Future<void> adddatadinas(File file, Map<String, dynamic> requestData) async {
    _myRepo
        .adddinas(file, requestData)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }

  Future<void> deletedinas(String id) async {
    _myRepo
        .deletedinas(id)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }

  //Add Cuti
  Future<void> adddatacuti(File file, Map<String, dynamic> requestData) async {
    _myRepo
        .addcuti(file, requestData)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }

  // Delete Cuti
  Future<void> deletecuti(String id) async {
    _myRepo
        .deletecuti(id)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }

  updatecutinoimage(Map<String, String> data) {
    _myRepo
        .updatecutinoimage(data)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }

  Future<void> updatecutiimage(
      File file, Map<String, dynamic> requestData) async {
    _myRepo
        .updatecutiuseimage(file, requestData)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }
}
