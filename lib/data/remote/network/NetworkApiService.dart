import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../AppException.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  //For Request GET
  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(baseUrl + url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

//For Request POST
  @override
  Future postResponse(String url, data) async {
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          headers: {
            "content-type": "application/json",
          },
          body: jsonEncode(data));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  //for POST MULTIPARTFILE
  Future postResponseMultipart(
      String url, File file, Map<String, dynamic> data) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));

      // Create a multipart file from the provided file
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );

      // Add the multipart file to the request
      request.files.add(multipartFile);
      // Add string data to the request
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add any additional headers if needed
      request.headers['content-type'] = 'multipart/form-data';

      // Send the request
      var streamedResponse = await request.send();

      // Convert the streamed response to a response object
      var response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
