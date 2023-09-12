import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/model/absensi/DetailAbsenModel.dart';
import 'package:absensi/repository/absensi/AbsensiRepo.dart';

import '../../data/remote/network/ApiEndPoints.dart';
import '../../data/remote/network/BaseApiService.dart';
import '../../data/remote/network/NetworkApiService.dart';
import '../../model/absensi/CutiModel.dart';
import '../../model/absensi/OutLocationModel.dart';

class AbsensiRepolpm implements AbsensiRepo {
  get http => null;
  BaseApiService _apiService = NetworkApiService();

  @override
  Future<AbsensiModel?> addabsensi(String id, String latitude, String longitude,
      String status, String swa, String jenis) async {
    try {
      Map<String, String> data = {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "swa": swa,
        "jenis": jenis
      };
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().addabsen, data);
      //print("$response");
      final jsonData = AbsensiModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<AbsensiModel?> addabsensiluarkantor(
      String id,
      String latitude,
      String longitude,
      String status,
      String swa,
      String jenis,
      String id_luarkantor) async {
    try {
      Map<String, String> data = {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "swa": swa,
        "jenis": jenis,
        "id_luarkantor": id_luarkantor
      };
      dynamic response = await _apiService.postResponse(
          ApiEndPoints().addabsenluarkantor, data);
      //print("$response");
      final jsonData = AbsensiModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<CutiModel?> getcuti(String id, String id_instansi) async {
    try {
      Map<String, String> data = {
        "id": id,
        "id_instansi": id_instansi,
      };
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().getcuti, data);
      //print("$response");
      final jsonData = CutiModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<DetailAbsenModel?> detailabsensi(Map<String, String> data) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().detailabsensi, data);
      //print("$response");
      final jsonData = DetailAbsenModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }

  @override
  Future<OutLocationModel?> getoutlocationrepo(Map<String, String> data) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().getoutlocation, data);
      //print("$response");
      final jsonData = OutLocationModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }
}
