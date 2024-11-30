import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String username = 'hema';
String password = 'hema12345';

String credentials = '$username:$password';
String encodedCredentials = base64.encode(utf8.encode(credentials));
String _basicAuth = 'Basic $encodedCredentials';

Map<String, String> myheaders = {'authorization': _basicAuth};

mixin class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error : ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch : $e");
    }
  }

  postRequest(String url, Map data) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      var response =
          await http.post(Uri.parse(url), body: data, headers: myheaders);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Erorr : ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch : $e");
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    request.headers.addAll(myheaders);
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);

    if (myrequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error ${myrequest.statusCode}");
    }
  }
}
