import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
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
                padding: EdgeInsets.only(left: 56.0, top: 56.0, right: 56.0),
                child: Image(image: AssetImage('images/joynimage.png')),
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: 96.0,
                      top: 103.0,
                      right: MediaQuery.of(context).size.width *
                          0.1), //right: 96.0),
                  child: Text(
                      //welcome text
                      'Feed Page',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'SFProDisplay')))
            ],
          ),
        ),
      ),
    );
  }
}
