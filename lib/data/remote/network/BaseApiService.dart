import 'dart:io';

abstract class BaseApiService {
  final String baseUrl = "https://absensi.bengkaliskab.go.id/api/absensiAPI/";
  //Untuk GET
  Future<dynamic> getResponse(String url);

  //untuk POST

  Future<dynamic> postResponse(String url, data);

  Future<dynamic> postResponseMultipart(
      String url, File file, Map<String, dynamic> data);
}
