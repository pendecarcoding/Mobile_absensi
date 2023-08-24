import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/model/absensi/DetailAbsenModel.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';

import '../../model/absensi/OutLocationModel.dart';

class AbsensiRepo {
  Future<AbsensiModel?> addabsensi(String id, String latitude, String longitude,
      String status, String swa, String jenis) async {}
  Future<CutiModel?> getcuti(String id, String id_instansi) async {}
  Future<DetailAbsenModel?> detailabsensi(Map<String, String> data) async {}
  Future<OutLocationModel?> getoutlocationrepo(
      Map<String, String> data) async {}
}
