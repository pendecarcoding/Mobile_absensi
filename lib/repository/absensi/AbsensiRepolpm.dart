import 'package:absensi/model/absensi/AbsensiModel.dart';
import 'package:absensi/repository/absensi/AbsensiRepo.dart';

import '../../data/remote/network/ApiEndPoints.dart';
import '../../data/remote/network/BaseApiService.dart';
import '../../data/remote/network/NetworkApiService.dart';

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
}
