import 'package:absensi/model/employee/EmployeeModel.dart';

import '../../data/remote/network/ApiEndPoints.dart';
import '../../data/remote/network/BaseApiService.dart';
import '../../data/remote/network/NetworkApiService.dart';
import 'PegawaiRepo.dart';

class PegawaiRepolpm implements PegawaiRepo {
  get http => null;
  BaseApiService _apiService = NetworkApiService();

  @override
  Future<EmployeeModel?> getlistemployee(id, kodeunitkerja) async {
    try {
      Map<String, String> data = {"id": id, "kode_unitkerja": kodeunitkerja};
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().getemployee, data);
      //print("$response");
      final jsonData = EmployeeModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
      print("MARAJ-E $e}");
    }
  }
}
