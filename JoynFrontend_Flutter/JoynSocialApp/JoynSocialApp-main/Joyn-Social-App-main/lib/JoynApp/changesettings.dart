import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/profilesettings.dart';

class ChangeSettings extends StatefulWidget {
  @override
  _ChangeSettingsState createState() => _ChangeSettingsState();
}

class _ChangeSettingsState extends State<ChangeSettings> {
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
          'Targeting Preferences',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'SFProDisplay'),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                Image.asset(
                  'images/profilephotoverify.png',
                  filterQuality: FilterQuality.high,
                  //height: 91.0,
                  //width: 90.0
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Decide what personal information we use to match you with sponsors. Remember, we never share any of this information with anyone.',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'SFProDisplay'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    color: const Color(0xFF09091F),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Demographic',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            SizedBox(
                              width: 180,
                            ),
                            Icon(
                              Icons.toggle_off_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Information such as your age, gender and country of residence.',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontFamily: 'SFProDisplay'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            color: const Color(0xFFFD6CCA),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0)),
                            textColor: Colors.white,
                            child: Text(
                              'Edit my demographic profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileSettings()),
                              );
                            }),
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    color: const Color(0xFF09091F),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Behavioural',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            SizedBox(
                              width: 195,
                            ),
                            Icon(
                              Icons.toggle_off_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Insights generated about you as you use this app. Such as: which accounts you follow, content you like and share, and hashtags you use.',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontFamily: 'SFProDisplay'),
                        ),
                        /* SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            color: const Color(0xFFFD6CCA),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0)),
                            textColor: Colors.white,
                            child: Text(
                              'Edit my demographic profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            onPressed: () {}), */
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    color: const Color(0xFF09091F),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Interests',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            SizedBox(
                              width: 225,
                            ),
                            Icon(
                              Icons.toggle_off_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                         Text(
                          'Things that you tell us you’re interested in. We might also suggest interests for you based on how you use Joyn.',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontFamily: 'SFProDisplay'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            color: const Color(0xFFFD6CCA),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0)),
                            textColor: Colors.white,
                            child: Text(
                              'Edit my interests',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'SFProDisplay'),
                            ),
                            onPressed: () {}),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
