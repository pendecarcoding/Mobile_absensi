import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../repository/absensi/AbsensiRepolpm.dart';

class AbsensiVM extends ChangeNotifier {
  final _myRepo = AbsensiRepolpm();

  ApiResponse<AbsensiModel> data = ApiResponse.loading();

  void _setMain(ApiResponse<AbsensiModel> response) {
    print("$response");
    data = response;
    notifyListeners();
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
}
