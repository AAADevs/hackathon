import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ItemServices {
  String likeUrl = 'http://167.71.239.221:8088/api/likePost';
  String unLikeUrl = 'http://167.71.239.221:8088/api/unLikePost';
  String followUrl = 'http://167.71.239.221:8088/api/followUser';
  String unfollowUrl = 'http://167.71.239.221:8088/api/unfollowUser';
  String getpopularposts = 'http://167.71.239.221:8088/api/getPopularPosts';

  Future<dynamic> likePost(String token, String postid) async {
    var headers = {
      'Authorization': token,
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(likeUrl));

    request.body = '''{\r\n    "post_id":"$postid"\r\n}  \r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      //print(response.);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> getPopularPosts(String token) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token
    };
    var request = http.Request('POST', Uri.parse(getpopularposts));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseJson = await http.Response.fromStream(response);

      var responsejson = json.decode(responseJson.body);
      //print(responsejson);
      return responsejson;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> unlikePost(String token, String postid) async {
    var headers = {
      'Authorization': token,
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(unLikeUrl));
    request.body = '''{\r\n    "post_id":"$postid"\r\n}  \r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> followUSer(String token, String userid) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/followUser'));
    request.body = '''{\r\n    "user_id":"$userid"\r\n}''';
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

  Future<dynamic> unfollowUSer(String token, String userid) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/unfollowUser'));
    request.body = '''{\r\n    "user_id":"$userid"\r\n}''';
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
