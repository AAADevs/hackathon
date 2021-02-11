import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

class AuthServices {
  String url1 = "https://api.passbase.com/verification/v1/identities/";
  String url2 = "http://167.71.239.221:8088/api/passbaseVerified";
  String url3 = "http://167.71.239.221:8088/api/getUserDetails";
  String url4 = "http://167.71.239.221:8088/api/verifyUser";
  String url5 = "http://167.71.239.221:8088/api/getAllFeeds";
  String url6 = 'http://167.71.239.221:8088/api/getUserFeeds';

  Future<dynamic> profileDetails(String token, String username) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url6));
    request.body = '''{\r\n    "username":"$username"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseJson = await http.Response.fromStream(response);

      var responsejson = json.decode(responseJson.body);
      print(responsejson);
      return responsejson;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> feedDetails(String token) async {
    var responseJson;
    print(token);
    try {
      final http.Response response = await http.post(
        url5,
        headers: <String, String>{
          "Accept": "application/json",
          "Authorization": token,
          "joyn_api_secret_key":
              "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
        },
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAllVibes(String token) async {
    var responseJson;
    var responsejson;
    print(token);
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
    };
    var request = await http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/getAllVibes'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      responseJson = await http.Response.fromStream(response);
      responsejson = json.decode(responseJson.body);
      print(responsejson);
      return responsejson;
    } else {
      print(response.reasonPhrase);
    }
    print(response.statusCode);
  }

  Future<dynamic> postNewFeedJot(List<dynamic> allPaths, String token,
      String text, String category) async {
    var headers = {
      'Authorization': token,
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
    };
    print(token);

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://167.71.239.221:8088/api/postNewFeedJot'));
    request.fields.addAll({
      'jotText': text,
      'category': category,
    });
    List<String> picExt = ['.jpg', '.jpeg', '.gif', '.png'];
    List<String> videoExt = ['.mp4'];

    for (var file in allPaths) {
      int j = file.lastIndexOf('.');

      print(file.substring(j));
      if (picExt.contains(file.substring(j))) {
        request.files.add(await http.MultipartFile.fromPath(
          'multi-files',
          file,
          contentType: new MediaType('image', file.substring(j + 1)),
        ));
      } else if (videoExt.contains(file.substring(j))) {
        request.files.add(await http.MultipartFile.fromPath(
          'multi-files',
          file,
          contentType: new MediaType('video', file.substring(j + 1)),
        ));
      }
    }

    print(request.fields);

    request.headers.addAll(headers);

    print(request.headers);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> postNewFeedPic(
      String _image, String token, String text, String category) async {
    Dio dio = new Dio();
    var response;
    var responseJson;
    String filename = _image.split('/').last;
    try {
      Map<String, dynamic> _map = {
        'multi-files': MultipartFile.fromFileSync(
          _image,
          filename: filename,
          contentType: new MediaType('image', 'jpeg'),
        ),
        "description": text,
        "category": category,
      };
      print("Request : $_map");
      FormData formData = FormData.fromMap(_map);
      String url = "http://167.71.239.221:8088/api/postNewFeedPic";
      Map<String, dynamic> mheaders = {
        "Accept": "*/*",
        "content-type": "multipart/form-data",
        "Authorization": token,
        "joyn_api_secret_key":
            "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
      };
      print("\n\n\n\n");
      print("Header: $mheaders");
      Options options = new Options(headers: mheaders);
      print("options : $options");
      response = await dio.post(url, data: formData, options: options);

      print("Response Upload: ${response.data}");

      if (response.statusCode == 200) {
        print("object");
      }
    } catch (e) {
      print(e);
    }
    return response.data;
  }

  Future<dynamic> postNewFeedVideo(
      String _image, String token, String text) async {
    Dio dio = new Dio();
    var response;
    var responseJson;
    String filename = _image.split('/').last;
    try {
      Map<String, dynamic> _map = {
        'multi-files': MultipartFile.fromFileSync(
          _image,
          filename: filename,
          contentType: new MediaType('video', 'mp4'),
        ),
        "description": text,
      };
      print("Request : $_map");
      FormData formData = FormData.fromMap(_map);
      String url = "http://167.71.239.221:8088/api/postNewFeedPic";
      Map<String, dynamic> mheaders = {
        "Accept": "*/*",
        "content-type": "multipart/form-data",
        "Authorization": token,
        "joyn_api_secret_key":
            "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
      };
      print("\n\n\n\n");
      print("Header: $mheaders");
      Options options = new Options(headers: mheaders);
      print("options : $options");
      response = await dio.post(url, data: formData, options: options);

      print("Response Upload: ${response.data}");

      if (response.statusCode == 200) {
        print("object");
      }
    } catch (e) {
      print(e);
    }
    return response.data;
  }

  Future<dynamic> postNewFeedVibe(
      String _image, String token, String text) async {
    var headers = {
      "Accept": "*/*",
      "content-type": "multipart/form-data",
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://167.71.239.221:8088/api/postNewFeedVibe'));
    request.fields.addAll({'vibeText': text});
    request.files.add(await http.MultipartFile.fromPath('multi-files', _image,
        contentType: new MediaType('video', 'mp4')));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return response;
  }

  Future<dynamic> postNewFeedPicVideo(
      List<dynamic> allUrls,
      List<dynamic> platformFiles,
      String token,
      String text,
      String category) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://167.71.239.221:8088/api/postNewFeedPic'));
    request.fields.addAll({
      'description': text,
      "category": category,
    });
    for (int i = 0, j = 0;
        i < platformFiles.length && j < allUrls.length;
        i++, j++) {
      if (platformFiles[i].extension == "jpg" ||
          platformFiles[i].extension == "jpeg" ||
          platformFiles[i].extension == "png" ||
          platformFiles[i].extension == "gif") {
        request.files.add(await http.MultipartFile.fromPath(
          'multi-files',
          allUrls[j],
          contentType: new MediaType('image', platformFiles[i].extension),
        ));
      } else if (platformFiles[i].extension == "mp4") {
        request.files.add(await http.MultipartFile.fromPath(
          'multi-files',
          allUrls[j],
          contentType: new MediaType('video', platformFiles[i].extension),
        ));
      }
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> verifyUser(
    String token,
  ) async {
    var responseJson;
    // final queryParameters = {
    //   "email": email,
    //   "username": username,
    // };
    // final uri = Uri.http(url4, "/api/verifyUser", {
    //   'email': email,
    //   'username': username,
    // });
    try {
      final http.Response response = await http.post(
        url4,
        headers: <String, String>{
          "Accept": "application/json",
          "Authorization": token,
          "joyn_api_secret_key":
              "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
        },
        // body: {
        //   "email": email,
        //   "username": username,
        // },
      );

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> userDetails(String token, String email) async {
    var responseJson;
    try {
      final http.Response response =
          await http.post(url3, headers: <String, String>{
        "Accept": "application/json",
        "Authorization": token,
        "joyn_api_secret_key":
            "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
      }, body: {
        "email": email,
      });

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> passbaseVerified(String email, String token) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url2));
    request.body = '''{\r\n    "email":"$email"\r\n    \r\n}\r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseJson = await http.Response.fromStream(response);

      var responsejson = json.decode(responseJson.body);
      print(responsejson);
      return responsejson;
    } else {
      print(response.reasonPhrase);
    }

    // var responseJson;
    // try {
    //   final http.Response response = await http.post(
    //     url2,
    //     headers: <String, String>{
    //       'Content-Type': 'application/json',
    //       "Authorization": token,
    //       "joyn_api_secret_key":
    //           "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
    //     },
    //     body: {
    //       "email": email,
    //     },
    //   );

    //   responseJson = _response(response);
    // } on SocketException {
    //   throw FetchDataException('No Internet connection');
    // }
    // return responseJson;
  }

  Future<dynamic> checkStatus(String identityId) async {
    var responseJson;
    try {
      final http.Response response = await http.get(
        url1 + '$identityId',
        headers: <String, String>{
          "Content-Type": "application/json",
          "X-API-KEY":
              "2aC0Q6uE90G2UpOMugrzCgFhXDwYb6cbarIs20RSHKiahQSaQI2SB6trjhKNKZzXabCTQNDKSzgERxHdKgRnaFbV58PYsgtZRhUlJFdVWaxulNOw26mK4sexzHnm2Ylh",
        },
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      case 404:
        var responseJson = json.decode(response.body);
        return responseJson;

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future getSearchData(String token, String searchText) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/searchUsers'));
    request.body = '''{\r\n    "username": "$searchText"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var tempResponse = await response.stream.bytesToString();
      Map valueMap = jsonDecode(tempResponse);
      return valueMap;
      // [
      //   valueMap["data"][0]["username"],
      //   valueMap["data"][0]["profile_picture"],
      //   valueMap["data"][0]["email"]
      // ];
    } else {
      print(response.reasonPhrase);
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
