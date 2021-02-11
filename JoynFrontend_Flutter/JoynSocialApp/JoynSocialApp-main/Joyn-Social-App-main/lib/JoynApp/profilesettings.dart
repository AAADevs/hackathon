import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.52),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: new Image.asset(
            "images/right-chevron.png",
            height: 25,
            width: 25,
          ),
          onPressed: () {},
        ),
        backgroundColor: const Color(0xFFFFC6C8),
        title: Text(
          'My Profile',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'SFProDisplay'),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Theme(
            data: new ThemeData(
              primaryColor: Colors.white,
            ),
            child: Column(children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Gender',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'SFProDisplay'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 230,
                      ),
                      IconButton(
                          icon: new Image.asset(
                            'images/pencil.png',
                            height: 30,
                            width: 33,
                            filterQuality: FilterQuality.high,
                          ),
                          onPressed: () {
                          }
                          ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Female',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SFProDisplay',
                              color: Colors.black),
                          //fillColor: Colors.black,
                          filled: true,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Nationality',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'SFProDisplay'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 200,
                      ),
                      IconButton(
                          icon: new Image.asset(
                            'images/pencil.png',
                            height: 30,
                            width: 33,
                            filterQuality: FilterQuality.high,
                          ),
                          onPressed: () {
                          }
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Indian',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SFProDisplay',
                              color: Colors.black),
                          //fillColor: Colors.black,
                          filled: true,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Country of Residence',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'SFProDisplay'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      IconButton(
                          icon: new Image.asset(
                            'images/pencil.png',
                            height: 30,
                            width: 33,
                            filterQuality: FilterQuality.high,
                          ),
                          onPressed: () {
                          }
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'India',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SFProDisplay',
                              color: Colors.black),
                          //fillColor: Colors.black,
                          filled: true,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Age',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'SFProDisplay'),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 260,
                      ),
                      IconButton(
                          icon: new Image.asset(
                            'images/pencil.png',
                            height: 30,
                            width: 33,
                            filterQuality: FilterQuality.high,
                          ),
                          onPressed: () {
                          }
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: '18',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SFProDisplay',
                              color: Colors.black),
                          //fillColor: Colors.black,
                          filled: true,
                          focusColor: Colors.black,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
            ]),
          ),
        ),
      ),
    );
  }
}
