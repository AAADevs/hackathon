import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'welcome.dart';

//signup page
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

String url1 = 'http://167.71.239.221:8088/api/userRegister';

class _SignUpState extends State<SignUp> {
  String email, username, password;
  var val1;
  bool loading = false;
  JoynTokenServices service = new JoynTokenServices();
  final TextEditingController email1Controller = new TextEditingController();
  final TextEditingController password1Controller = new TextEditingController();
  final TextEditingController usernameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.52),
      resizeToAvoidBottomInset: true,
      body: Container(
        //to specify the background
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background3x.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(primaryColor: Color(0xFFFD6CCA)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Container(
                  //add the name of the application
                  padding: EdgeInsets.only(left: 56.0, top: 56.0, right: 56.0),
                  child: Image(image: AssetImage('images/joynimage.png'))),
              Container(
                //text 'create account'
                padding: EdgeInsets.only(top: 21.0), //left: 107.0, right: 107.0
                child: Text('Create Account',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'SFProDisplay')),
              ),
              Container(
                //email input field
                padding: EdgeInsets.only(left: 20.0, top: 14.0, right: 19.0),

                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: email1Controller,
                  obscureText: false,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                //username input field
                padding: EdgeInsets.only(left: 20.0, top: 23.0, right: 19.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: usernameController,
                  obscureText: false,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  onTap: showField(),
                  decoration: InputDecoration(
                    hintText: 'Username',
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
                padding: EdgeInsets.only(left: 20.0, top: 9.0, right: 19.0),

                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: password1Controller,
                  obscureText: true,
                  cursorColor: Colors.black,
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
              SizedBox(
                height: 26.0,
              ),
              MaterialButton(
                //create account button
                elevation: 0,
                height: 50.0,
                minWidth: 336.0,
                onPressed: () async {
                  // ignore: unrelated_type_equality_checks
                  if ((email1Controller.text.length) != 0 &&
                      (usernameController.text.length) <= 30 &&
                      (password1Controller.text.length) != 0) {
                    bool userValid = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]')
                        .hasMatch(usernameController.text);
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email1Controller.text);
                    if (emailValid == true && userValid == false) {
                      await create(email1Controller.text,
                              password1Controller.text, usernameController.text)
                          .then((val) async {
                        String jsonsDataString = val.toString();
                        final jsonData = jsonDecode(jsonsDataString);
                        if (jsonData["msg"] == "User registered successfully") {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // prefs.setString('emailValue', email);
                          // prefs.setString('passValue', pass);
                          // prefs.setString('userName', username);
                          var createHedera = await service
                              .createAccount(usernameController.text)
                              .then((value) async {
                            var addToken =
                                await service.addToken(usernameController.text);
                            print(addToken);
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Welcome(
                                jsonData["details"]["username"],
                                jsonData["details"]["email"],
                              ),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Email address or username already exists',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0x80FD6CCA),
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'Invalid email address or username. Username can have only 30 characters with numbers and letters only',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0x80FD6CCA),
                          textColor: Colors.white,
                          fontSize: 14.0);
                    }
                    /*else{
                      print("Fill in details");
                    }*/
                  }
                },
                color: const Color(0x80FD6CCA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SFProDisplay'),
                ),
                textColor: Colors.white,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> create(String email, pass, user) async {
  //api call
  http.Response response = await http.post(
    "http://167.71.239.221:8088/api/userRegister",
    headers: {
      "Content-Type": "application/json",
      "joyn_api_secret_key":
          "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W"
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "username": user,
      "password": pass,
    }),
  );
  return response.body;
}

showField() {
  Fluttertoast.showToast(
      msg: '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.transparent,
      textColor: Colors.white,
      fontSize: 14.0);
}
