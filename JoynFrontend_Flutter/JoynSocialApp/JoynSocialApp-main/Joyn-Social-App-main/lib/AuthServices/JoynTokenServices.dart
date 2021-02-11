import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class JoynTokenServices {
  String createaccount =
      'http://167.71.239.221:8088/api/createAccountAssociateTransfer';
  String accInfo = 'http://167.71.239.221:8088/api/getAccountInfo';
  String wallpapersButtons =
      'http://167.71.239.221:8088/api/purchasedAndUnpurchasedItem';
  String purchaseUrl = 'http://167.71.239.221:8088/api/purchase';
  String setDefaultUrl = 'http://167.71.239.221:8088/api/setDefault';
  String uploadtoShop = 'http://167.71.239.221:8088/api/uploadAssetToShop';

  Future<dynamic> transferTokentoUser(
      String token, String sender, String receiver, String tokenAmount) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/transferToken'));
    request.body =
        '''{\r\n\t"sender":"$sender",\r\n\t"receiver":"$receiver",\r\n\t"tokenAmount":"$tokenAmount"\r\n}\r\n''';
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

  Future<dynamic> setDefault(String token, String iD) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(setDefaultUrl));
    request.body = '''{\r\n    "id":"$iD"\r\n    \r\n}\r\n''';
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

  Future<dynamic> uploadItemtoShop(String token, String type, String name,
      String price, String imageURL) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token
    };
    var request = http.MultipartRequest('POST', Uri.parse(uploadtoShop));
    request.fields.addAll({
      'type': type,
      'name': name,
      'price': price,
    });
    request.files.add(
      await http.MultipartFile.fromPath('multi-files', imageURL),
    );
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

  Future<dynamic> purchase(String token, String iD) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/purchase'));
    request.body = '''{\r\n    "id":"$iD"\r\n    \r\n}\r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> wallpapersAndButtons(String token) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Authorization': token,
    };
    var request = http.Request('GET', Uri.parse(wallpapersButtons));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      var responseJson = await http.Response.fromStream(response);

      var responsejson = json.decode(responseJson.body);
      print(responsejson);
      return responsejson;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> addToken(String username) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/addToken'));
    request.body =
        '''{\r\n\t"username":"$username",\r\n\t"tokenAmount":"200"\r\n}\r\n''';
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

  Future<dynamic> deductTokens(
      String amount, String token, String username) async {
    var headers = {
      'Authorization': token,
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://167.71.239.221:8088/api/deductToken'));
    request.body =
        '''{\r\n    "username":"$username",\r\n    "tokenAmount":"$amount"\r\n}  \r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> createAccount(String username) async {
    var headers = {
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(createaccount));
    request.body = '''{\r\n    "username":"$username"\r\n}  \r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> accountInfo(String token, String username) async {
    var headers = {
      'Authorization': token,
      'joyn_api_secret_key':
          '\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(accInfo));
    request.body = '''{\r\n    "username":"$username"\r\n}  \r\n''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //var responseJson = await response.stream.bytesToString();
      var responseJson = await http.Response.fromStream(response);
      //print(await response.stream.bytesToString());
      //print(responseJson.body);
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
