import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/CutiModel.dart';
import 'package:absensi/model/employee/EmployeeModel.dart';

class AbsensiRepo {
  Future<AbsensiModel?> addabsensi(String id, String latitude, String longitude,
      String status, String swa, String jenis) async {}
  Future<CutiModel?> getcuti(String id, String id_instansi) async {}
}
