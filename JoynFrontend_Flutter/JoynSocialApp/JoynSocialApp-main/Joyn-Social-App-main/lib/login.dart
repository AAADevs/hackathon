import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:joyn_social_app/signup.dart';
import 'package:joyn_social_app/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

//login page

class LogIn extends StatefulWidget {
  static const String routeName = "http://167.71.239.221:8088/api/userLogin";
  @override
  _LogInState createState() => _LogInState();
}

String url = "http://167.71.239.221:8088/api/userLogin";

class _LogInState extends State<LogIn> {
  var val;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  AuthServices service = new AuthServices();
  var status;
  String passbaseVerified = "Verified";
  String passbaseIncomplete = "Not Completed";

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
                        padding:
                            EdgeInsets.only(left: 56.0, top: 56.0, right: 56.0),
                        child: Image(image: AssetImage('images/joynimage.png')),
                      ),
                      Container(
                        width: double.infinity,
                        //text
                        padding: EdgeInsets.only(
                          top: 26.0,
                        ),
                        child: Text(
                          'Existing User? Log In',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontFamily: 'SFProDisplay'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        //email or username input field
                        padding:
                            EdgeInsets.only(left: 20.0, top: 17.0, right: 19.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Email or username',
                            hintStyle: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'SFProDisplay',
                                color: Colors.white),
                            fillColor: Colors.white24,
                            filled: true,
                            focusColor: const Color(0x66FFFFFF),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      Container(
                        //password input field
                        padding:
                            EdgeInsets.only(left: 20.0, top: 23.0, right: 19.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: passwordController,
                          obscureText: true,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'SFProDisplay',
                                color: Colors.white),
                            fillColor: Colors.white24,
                            filled: true,
                            focusColor: Colors.white24,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 200.0,
                            top: 6.0,
                            right: MediaQuery.of(context).size.width *
                                0.03), //right: 19.0),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFFFD6CCA),
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SFProDisplay'),
                        ),
                      ),
                      SizedBox(
                        height: 39.0,
                      ),
                      MaterialButton(
                        //login button
                        elevation: 0,
                        height: 50.0,
                        minWidth: 336.0,
                        color: const Color(0x80FD6CCA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        textColor: Colors.white,
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          String passbaseId = prefs.getString('userPassbaseId');

                          if ((emailController.text.length) != 0 &&
                              (passwordController.text.length) != 0) {
                            signIn(emailController.text,
                                    passwordController.text)
                                .then(
                              (val) async {
                                String jsonsDataString = val.toString();
                                final jsonData = jsonDecode(jsonsDataString);
                                print(jsonData);
                                if (jsonData['token'] != null) {
                                  showToast1(jsonData);
                                  addStringToSF(
                                    jsonData['email'],
                                    passwordController.text,
                                    jsonData['username'],
                                    jsonData['token'],
                                  );
                                  var value = getValue() ?? "";
                                  var getUserDetails =
                                      await service.userDetails(
                                          jsonData['token'], jsonData['email']);
                                  if (getUserDetails["data"][0]["passbase"] ==
                                      false) {
                                    if (passbaseId != null) {
                                      status =
                                          await service.checkStatus(passbaseId);
                                      if (status["status"] == 'approved') {
                                        var data =
                                            await service.passbaseVerified(
                                                jsonData['email'],
                                                jsonData['token']);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MainScreen(
                                              wallpaperUrl:
                                                  getUserDetails["data"][0]
                                                      ["currentWallpaper"],
                                              homebuttonUrl:
                                                  getUserDetails["data"][0]
                                                      ["currentHomebutton"],
                                              passbaseverified: true,
                                              passbaseStatus: status["status"],
                                            ),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      } else {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MainScreen(
                                              wallpaperUrl:
                                                  getUserDetails["data"][0]
                                                      ["currentWallpaper"],
                                              homebuttonUrl:
                                                  getUserDetails["data"][0]
                                                      ["currentHomebutton"],
                                              passbaseverified: false,
                                              passbaseStatus: status["status"],
                                            ),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    } else {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MainScreen(
                                            wallpaperUrl: getUserDetails["data"]
                                                [0]["currentWallpaper"],
                                            homebuttonUrl:
                                                getUserDetails["data"][0]
                                                    ["currentHomebutton"],
                                            passbaseverified: false,
                                            passbaseStatus: passbaseIncomplete,
                                          ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MainScreen(
                                          wallpaperUrl: getUserDetails["data"]
                                              [0]["currentWallpaper"],
                                          homebuttonUrl: getUserDetails["data"]
                                              [0]["currentHomebutton"],
                                          passbaseverified: true,
                                          passbaseStatus: passbaseVerified,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                  // Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MainScreen(
                                  //             wallpaperUrl: getUserDetails["data"]
                                  //                 [0]["currentWallpaper"],
                                  //             homebuttonUrl:
                                  //                 getUserDetails["data"][0]
                                  //                     ["currentHomebutton"],
                                  //           )),
                                  //   (Route<dynamic> route) => false,
                                  // );
                                  // Welcome(
                                  //   jsonData['username'],
                                  //   jsonData['email'],
                                  //   jsonData['token'],
                                  // ),
                                } else {
                                  showToast(jsonData);
                                }
                              },
                            );
                          }
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SFProDisplay'),
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Row(
                        //or divider
                        children: <Widget>[
                          Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 15.0),
                              child: Divider(
                                color: Colors.white,
                                height: 50,
                              ),
                            ),
                          ),
                          Text("OR",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontFamily: 'SFProDisplay',
                              )),
                          Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Divider(
                                color: Colors.white,
                                height: 50,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don’t have an account?',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            MaterialButton(
                              //sign up button
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()),
                                );
                              },
                              child: Text(
                                'Sign up.',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFFFD6CCA),
                                    fontFamily: 'SFProDisplay'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
            )));
  }
}

Future<dynamic> signIn(String email, pass) async {
  //api call
  http.Response response = await http.post(
    "http://167.71.239.221:8088/api/userLogin",
    headers: {
      "Content-Type": "application/json",
      "joyn_api_secret_key":
          "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
    },
    body: jsonEncode(<String, String>{
      "email_username": email,
      "password": pass,
    }),
  );
  return response.body;
}

void showToast(jsonData) {
  Fluttertoast.showToast(
      msg: jsonData['error'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0x80FD6CCA),
      textColor: Colors.white,
      fontSize: 14.0);
}

void showToast1(jsonData) {
  Fluttertoast.showToast(
      msg: "Successfully Logged In!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0x80FD6CCA),
      textColor: Colors.white,
      fontSize: 14.0);
}

addStringToSF(String email, String pass, String username, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('emailValue', email);
  prefs.setString('passValue', pass);
  prefs.setString('userName', username);
  prefs.setString('token', token);
}
