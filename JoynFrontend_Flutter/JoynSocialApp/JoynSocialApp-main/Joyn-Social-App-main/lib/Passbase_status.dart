import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joyn_social_app/feed.dart';
import 'package:joyn_social_app/passbase.dart';

import 'AuthServices/authservices.dart';
import 'login.dart';

class CheckStatusPage extends StatefulWidget {
  final authkey;
  final data;
  CheckStatusPage({
    Key key,
    this.authkey,
    this.data,
  }) : super(key: key);

  @override
  _CheckStatus createState() => _CheckStatus();
}

class _CheckStatus extends State<CheckStatusPage> {
  double percent;

// Intialize 'Continue' & 'Retry' buttons depending on verification status.

  @override
  void initState() {
    if (widget.data["status"] == "created") {
      print("created");
    } else if (widget.data["status"] == "processing") {
      print("processing");
    } else if (widget.data["status"] == "pending") {
      print("pending");
    } else if (widget.data["status"] == "approved") {
      setState(() {
        _complete = false;
      });
    } else if (widget.data["status"] == "declined") {
      setState(() {
        _declined = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String platformResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthServices service = new AuthServices();
  bool _complete = true;
  bool _declined = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(8, 106, 175, 1.0),
      body: new Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background3x.png"),
                fit: BoxFit.cover)),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Passbase\nVerification  Status\n\n',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Image(
                image: AssetImage('images/passbase-logo-icon.png'),
                height: 100.0,
                width: 200.0,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'ID : ' + widget.data["status"],
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _complete
                    ? null
                    : MaterialButton(
                        elevation: 0,
                        height: 50.0,
                        minWidth: 336.0,
                        color: const Color(0x80FD6CCA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        textColor: Colors.white,

                        // onPressed: () async {
                        //   SharedPreferences token =
                        //       await SharedPreferences.getInstance();
                        //   String tk = token.getString('token');
                        // SharedPreferences email =
                        //     await SharedPreferences.getInstance();
                        // String em = email.getString('email');

                        //var data = await service.passbaseVerified(em, tk);

                        onPressed: () {
                          showToast2();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Feed()));
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SFProDisplay'),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _declined
                    ? null
                    : MaterialButton(
                        elevation: 0,
                        height: 50.0,
                        minWidth: 336.0,
                        color: const Color(0x80FD6CCA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassbaseDemoHomePage()),
                          );
                        },
                        child: Text(
                          'Retry',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SFProDisplay'),
                        ),
                      ),
              ),
              Padding(padding: new EdgeInsets.only(bottom: 30.0)),
            ],
          ),
        ),
      ),
    );
  }
}

void showToast2() {
  Fluttertoast.showToast(
      msg: "Successfully Verified",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0x80FD6CCA),
      textColor: Colors.white,
      fontSize: 14.0);
}
