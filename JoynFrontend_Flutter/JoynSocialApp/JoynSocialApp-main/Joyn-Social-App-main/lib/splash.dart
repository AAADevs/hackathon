import 'dart:async';
import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:joyn_social_app/feed.dart';
import 'package:joyn_social_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JoynApp/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  var verifyuser;
  var getUserDetails;
  bool verified = false;
  var status;
  String passbaseVerified = "Verified";
  String passbaseIncomplete = "Not Completed";
  AuthServices service = new AuthServices();

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('userName');
    String email = prefs.getString('emailValue');
    String token = prefs.getString('token');
    String passbaseId = prefs.getString('userPassbaseId');

    if (username == null || email == null || token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LogIn()),
      );
    } else if (username != null || email != null || token != null) {
      verifyuser = await service.verifyUser(token);

      print(token);
      if (verifyuser["result"] == true) {
        getUserDetails = await service.userDetails(token, email);
        prefs.setString('accountID', getUserDetails["data"][0]["_id"]);
        //print(getUserDetails["data"][0]["_id"]);
        if (getUserDetails["data"][0]["passbase"] == false) {
          if (passbaseId != null) {
            status = await service.checkStatus(passbaseId);
            if (status["status"] == 'approved') {
              var data = await service.passbaseVerified(email, token);
              print(data);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                    wallpaperUrl: getUserDetails["data"][0]["currentWallpaper"],
                    homebuttonUrl: getUserDetails["data"][0]
                        ["currentHomebutton"],
                    passbaseverified: true,
                    passbaseStatus: status["status"],
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                    wallpaperUrl: getUserDetails["data"][0]["currentWallpaper"],
                    homebuttonUrl: getUserDetails["data"][0]
                        ["currentHomebutton"],
                    passbaseverified: false,
                    passbaseStatus: status["status"],
                  ),
                ),
              );
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                  wallpaperUrl: getUserDetails["data"][0]["currentWallpaper"],
                  homebuttonUrl: getUserDetails["data"][0]["currentHomebutton"],
                  passbaseverified: false,
                  passbaseStatus: passbaseIncomplete,
                ),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(
                wallpaperUrl: getUserDetails["data"][0]["currentWallpaper"],
                homebuttonUrl: getUserDetails["data"][0]["currentHomebutton"],
                passbaseverified: true,
                passbaseStatus: passbaseVerified,
              ),
            ),
          );
        }
      } else if (verifyuser["result"] == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LogIn()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.52),
      resizeToAvoidBottomInset: true,
      body: Container(
        //to specify the background image
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background3x.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Theme(
            data: new ThemeData(
              primaryColor: Color(0xFFFD6CCA),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                Container(
                  //the name of the application
                  padding: EdgeInsets.only(left: 56.0, top: 56.0, right: 56.0),
                  child: Image(image: AssetImage('images/joynimage.png')),
                ),
                SizedBox(
                  height: 100,
                ),
                // Container(
                //   height: 30,
                //   child: CircularProgressIndicator(),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
