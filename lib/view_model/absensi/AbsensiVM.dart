import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/model/absensi/DetailAbsenModel.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../model/absensi/OutLocationModel.dart';
import '../../repository/absensi/AbsensiRepolpm.dart';

class AbsensiVM extends ChangeNotifier {
  final _myRepo = AbsensiRepolpm();

  ApiResponse<AbsensiModel> data = ApiResponse.loading();
  ApiResponse<DetailAbsenModel> absen = ApiResponse.loading();
  ApiResponse<CutiModel> datacuti = ApiResponse.loading();
  ApiResponse<OutLocationModel> outlocation = ApiResponse.loading();

  void _setMainAbsen(ApiResponse<DetailAbsenModel> response) {
    print("$response");
    absen = response;
    notifyListeners();
  }

  void _setMain(ApiResponse<AbsensiModel> response) {
    print("$response");
    data = response;
    notifyListeners();
  }

  void _setMainOutLocation(ApiResponse<OutLocationModel> response) {
    print("$response");
    outlocation = response;
    notifyListeners();
  }

  void _setMainCuti(ApiResponse<CutiModel> response) {
    print("$response");
    datacuti = response;
    notifyListeners();
  }

  Future<void> detailabsensi(Map<String, String> data) async {
    _myRepo
        .detailabsensi(data)
        .then((value) => _setMainAbsen(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainAbsen(ApiResponse.error(error.toString())));
  }

// get Outlocation
  Future<void> getoutlocation(Map<String, String> data) async {
    _myRepo
        .getoutlocationrepo(data)
        .then((value) => _setMainOutLocation(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainOutLocation(ApiResponse.error(error.toString())));
  }

  //Login Data
  Future<void> addabsensi(String id, String latitude, String longitude,
      String status, String swa, String jenis) async {
    _myRepo
        .addabsensi(id, latitude, longitude, status, swa, jenis)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }

  //Cuti
  Future<void> getcuti(String id, String id_istansi) async {
    _myRepo
        .getcuti(id, id_istansi)
        .then((value) => _setMainCuti(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMainCuti(ApiResponse.error(error.toString())));
  }
}
