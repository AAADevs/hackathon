import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joyn_social_app/addphoto.dart';
import 'package:joyn_social_app/verify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

//welcome page will be changed later on after verifications
class Welcome extends StatefulWidget {
  final username;
  final email;
  //final auth_token;
  Welcome(this.username, this.email, {Key key}) : super(key: key);
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Dio dio = new Dio();
  File _image;
  var response;

  Future<dynamic> uploadProfilePic(File _image) async {
    try {
      Map<String, dynamic> _map = {
        'image':
            MultipartFile.fromFileSync(_image.path, filename: "fileName.png"),
        "email": widget.email,
        //"username": widget.username,
      };
      print("Request : $_map");
      FormData formData = FormData.fromMap(_map);
      String url = "http://167.71.239.221:8088/api/uploadProfilePicture";
      Map<String, dynamic> mheaders = {
        "Accept": "application/json",
        "content-type": "multipart/form-data",
        //"Authorization": widget.auth_token,
        "username": widget.username,
        "joyn_api_secret_key":
            "\$2b\$10\$51OTEToXGbje5wpRQVrl6uoXNFKZMOptzh/HQBEl3HOkGLNoQZP8W",
      };
      print("\n\n\n\n");
      print("Header: $mheaders");
      Options options = new Options(headers: mheaders);
      response = await dio.post(url, data: formData, options: options);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profilepic', response.data['image_url']);

      print("Response Upload: ${response.data}");
      print(response.data['Location']);
      if (response.statusCode == 200) {
        print("object");
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 103.0,
                ), //right: 96.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        //welcome text
                        'Welcome, ',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'SFProDisplay')),
                    Text(
                      widget.username,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFFFD6CCA),
                          fontFamily: 'SFProDisplay'),
                    )
                  ],
                ),
              ),
              Container(
                //to add the profile photo
                padding: EdgeInsets.only(left: 112.0, top: 31.0, right: 112.0),
                child: Image(image: AssetImage('images/profilephoto2x.png')),
              ),
              SizedBox(
                height: 33.0,
              ),
              MaterialButton(
                //add profile photo button
                elevation: 0,
                height: 50.0,
                minWidth: 336.0,
                color: const Color(0xFFFD6CCA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                textColor: Colors.white,
                onPressed: () async {
                  File image = (await ImagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50)) as File;
                  setState(() {
                    _image = image;
                  });

                  if (_image != null) {
                    uploadProfilePic(_image).whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Verify(
                              widget.username, response.data['image_url']),
                        ),
                      );
                    });
                  } else {
                    print("Error");
                  }
                },
                child: Text(
                  'Add profile photo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SFProDisplay'),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 17.0),
                //right: 154.0),
                child: MaterialButton(
                  //sign up button
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Verify(widget.username, "")),
                    );
                  },
                  child: Text(
                    'Skip this',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'SFProDisplay'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> getValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('emailValue');
  return stringValue;
}
