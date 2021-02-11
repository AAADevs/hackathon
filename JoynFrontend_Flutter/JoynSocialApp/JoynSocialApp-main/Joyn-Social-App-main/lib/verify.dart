import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:joyn_social_app/login.dart';
import 'package:joyn_social_app/verification.dart';

class Verify extends StatefulWidget {
  final name;
  final dp;
  Verify(this.name, this.dp, {Key key}) : super(key: key);
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
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
                  padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(

                              //welcome text
                              'Welcome, ',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SFProDisplay')),
                          Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(

                                  //welcome text
                                  widget.name,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFFFD6CCA),
                                      fontFamily: 'SFProDisplay'))),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 38,
                        child: (widget.dp == "")
                            ? CircleAvatar(
                                backgroundColor: Color(0xFFFD6CCA),
                                radius: 34.0,
                                child: Center(
                                    child: Image(
                                        image: AssetImage(
                                            'images/profilephoto2x.png'))),
                              )
                            : CircleAvatar(
                                radius: 33.0,
                                backgroundColor: Color(0xFFFD6CCA),
                                backgroundImage: NetworkImage("${widget.dp}"),
                              ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.0, top: 43.0, right: 35.0),
                  child: Text(
                      //welcome text
                      'On Joyn, we verify our users so we know every user is a real person.'
                      '\n                                                                                                                                                                                                                                                                                                     '
                      '                                                                                                                                                                      '
                      'The verification process only takes a couple of minutes. You’ll have to take a selfie and you’ll need a government issued ID.',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'SFProDisplay')),
                ),
                SizedBox(
                  height: 36.0,
                ),
                MaterialButton(
                  //add profile photo button
                  elevation: 0,
                  height: 50.0,
                  minWidth: 336.0,
                  color: const Color(0xFFFD6CCA),

                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0)),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Verification()),
                    );
                  },
                  child: Text(
                    'Verify Me!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'SFProDisplay'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30.0, top: 140.0),
                  child: Text(
                      //welcome text
                      'You can browse Joyn without verifying yourself, but you won’t be able to post anything or interact with content.',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFFC6C6C6),
                          fontFamily: 'SFProDisplay')),
                ),
                SizedBox(
                  height: 15.0,
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                MaterialButton(
                  //add profile photo button

                  elevation: 0,
                  height: 35.0,
                  minWidth: 154.0,
                  padding: EdgeInsets.only(
                      left: 25.0,
                      right: MediaQuery.of(context).size.width * 0.1),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color(0xFFC6C6C6)),
                  ),
                  textColor: const Color(0xFFC6C6C6),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    'Verify Later',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'SFProDisplay'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
