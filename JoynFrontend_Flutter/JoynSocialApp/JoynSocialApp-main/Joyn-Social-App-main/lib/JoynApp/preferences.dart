import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/changesettings.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
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
        backgroundColor: const Color(0xFF09091F),
        title: Text(
          'Privacy Portal',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'SFProDisplay'),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: new Image.asset(
                "images/cog.png",
                height: 30,
                width: 33,
                filterQuality: FilterQuality.high,
                color: Colors.white,
                //fit: BoxFit.contain,
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>ChangeSettings()),
                );
              }
          ),
        ],
      ),
      body: Container(
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
                Image.asset('images/profilephotoverify.png',
                  filterQuality: FilterQuality.high,
                height: 91.0,
                width: 90.0),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'My Balance',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'SFProDisplay'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "images/tokenbutton.png",
                  height: 30,
                  width: 33,

                  filterQuality: FilterQuality.high,
                  //fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
