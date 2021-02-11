import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/Passbase_status.dart';
import 'package:joyn_social_app/passbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  AuthServices service = new AuthServices();

  @override
  void initState() {
    super.initState();
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
                padding: EdgeInsets.only(left: 25.0, top: 72.0, right: 38.0),
                child: Text(
                    //welcome text
                    'Choose Digital ID Verification Provider:',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontFamily: 'SFProDisplay')),
              ),
              SizedBox(
                height: 27.0,
              ),
              MaterialButton(
                  //add profile photo button
                  elevation: 0,
                  height: 106.0,
                  minWidth: 319.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: const Color(0xFFC6C6C6))),
                  textColor: const Color(0xFFC6C6C6),
                  onPressed: () {},
                  child: Image(image: AssetImage('images/YOTILogo2x.png'))),
              SizedBox(
                height: 27.0,
              ),
              MaterialButton(
                  //add profile photo button
                  elevation: 0,
                  height: 106.0,
                  minWidth: 319.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: const Color(0xFFC6C6C6))),
                  textColor: const Color(0xFFC6C6C6),
                  onPressed: () async {},
                  child: Image(image: AssetImage('images/verfied.me@2x.png'))),
              SizedBox(
                height: 27.0,
              ),
              MaterialButton(
                //add profile photo button
                elevation: 0,
                height: 106.0,
                minWidth: 319.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color(0xFFC6C6C6))),
                textColor: const Color(0xFFC6C6C6),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool status = prefs.getBool('passbasestatus');
                  SharedPreferences iD = await SharedPreferences.getInstance();
                  String id = iD.getString('userID');

                  if (status == null || status == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PassbaseDemoHomePage()),
                    );
                  } else {
                    AuthServices verificationstatus = new AuthServices();
// API call to check current status of passbase verification.
                    var data = await verificationstatus.checkStatus(id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckStatusPage(data: data)),
                    );
                  }
                },
                child: Image(
                  image: AssetImage('images/passbase-logo-icon.png'),
                  height: 100.0,
                  width: 200.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
