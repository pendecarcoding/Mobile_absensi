import 'package:absensi/model/employee/EmployeeModel.dart';
import 'package:absensi/repository/pegawai/PegawaiRepolpm.dart';
import 'package:flutter/cupertino.dart';

import '../../data/remote/response/ApiResponse.dart';
import '../../model/login/LoginModel.dart';
import '../../repository/login/LoginRepolpm.dart';

class PegawaiVM extends ChangeNotifier {
  final _myRepo = PegawaiRepolpm();

  ApiResponse<EmployeeModel> data = ApiResponse.loading();

  void _setMain(ApiResponse<EmployeeModel> response) {
    print("$response");
    data = response;
    notifyListeners();
  }

  //Login Data
  Future<void> getdata(String id, String kodeunitkerja) async {
    _myRepo
        .getlistemployee(id, kodeunitkerja)
        .then((value) => _setMain(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            _setMain(ApiResponse.error(error.toString())));
  }
}
