abstract class BaseApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/absensiAPI/";
  //Untuk GET
  Future<dynamic> getResponse(String url);

  //untuk POST

  Future<dynamic> postResponse(String url, data);
}
