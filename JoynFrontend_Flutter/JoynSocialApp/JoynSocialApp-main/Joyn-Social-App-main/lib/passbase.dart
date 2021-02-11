import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:joyn_social_app/feed.dart';
import 'package:joyn_social_app/login.dart';
import 'package:joyn_social_app/verification.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:joyn_social_app/Passbase_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassbaseDemoHomePage extends StatefulWidget {
  final username;
  final auth_token;
  final email;
  final String country = "";

  PassbaseDemoHomePage({Key key, this.email, this.username, this.auth_token})
      : super(key: key);
  Map data = {'country': 'US'};
  @override
  _PassbaseDemoHomePageState createState() {
    PassbaseSDK.initialize(
        publishableApiKey:
            "PbOIKIWoTjSXlcycRUOxoZYiGhC25flmanpg1ReqLZmB9OPkfdJNEzf3fVh2QAG3");
    //PassbaseSDK.prefillUserEmail = email; //optional
    return _PassbaseDemoHomePageState();
  }
}

class _PassbaseDemoHomePageState extends State<PassbaseDemoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.52),
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background3x.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 56.0, top: 56.0, right: 56.0),
                child: Image(image: AssetImage('images/joynimage.png')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: PassbaseButton(
                  onFinish: (identityAccessKey) async {
                    // do stuff in case of success
                    print(identityAccessKey);
                    // Save passbase ID for status(approved/declined) checking.
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('passbasestatus', true);
                    prefs.setString('userPassbaseId', identityAccessKey);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                  onError: (errorCode) {
// do stuff in case of cancel
                    print(errorCode);
                  },
                  onStart: () {
// do stuff in case of start
                    print("start");
                  },
                  width: 300,
                  height: 70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
