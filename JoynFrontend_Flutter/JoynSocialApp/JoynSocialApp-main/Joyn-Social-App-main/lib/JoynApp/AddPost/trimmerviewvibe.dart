import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../home.dart';
import '../main_screen.dart';

class TrimmerViewVibe extends StatefulWidget {
  final Trimmer _trimmer;

  TrimmerViewVibe(this._trimmer);
  @override
  _TrimmerViewVibeState createState() => _TrimmerViewVibeState();
}

class _TrimmerViewVibeState extends State<TrimmerViewVibe> {
  double _startValue = 0.0;
  double _endValue = 0.0;

  AuthServices service = new AuthServices();

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await widget._trimmer
        .saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      // ffmpegCommand:
      //     '-i /Photos/video.mp4 -ss 00:00:03 -t 00:00:05 -vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0',
    )
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09091F),
        title: ImageIcon(
          AssetImage('images/joynimage.png'),
          //color: Colors.white,
          size: 70,
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: _progressVisibility
                  ? null
                  : () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String token = prefs.getString('token');
                      String email = prefs.getString('emailValue');
                      var userData = await service.userDetails(token, email);

                      var data = await _saveVideo().then((outputPath) {
                        //Navigator.pop(context, outputPath);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostFeedVibe(
                              profileData: userData,
                              allUrl: outputPath,
                            ),
                          ),
                        );
                      });
                    },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'VAG'),
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.filter_list,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(),
                ),
                Center(
                  child: TrimEditor(
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    maxVideoLength: Duration(seconds: 15),
                    showDuration: true,
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                FlatButton(
                  child: _isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState =
                        await widget._trimmer.videPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostFeedVibe extends StatefulWidget {
  final profileData;
  final feedData;
  final allUrl;

  PostFeedVibe({
    Key key,
    this.allUrl,
    this.profileData,
    this.feedData,
  }) : super(key: key);

  @override
  _PostFeedVibe createState() => _PostFeedVibe();
}

class _PostFeedVibe extends State<PostFeedVibe> {
  TextEditingController textController = new TextEditingController();
  bool _progressVisibility = false;
  var userDetails;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.getUserDetails();
  }

  String platformResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String passbaseVerified = "Verified";
  AuthServices service = new AuthServices();

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('emailValue');
    String token = prefs.getString('token');

    userDetails = await service.userDetails(token, email);
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent.withOpacity(0.52),
      body: Container(
        //to specify the background image
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/BkgGradientFeed.png"),
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
                    height: 25,
                  ),
                  Visibility(
                    visible: _progressVisibility,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          'New Vibe',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'VAG'),
                        ),
                      ),
                      trailing: MaterialButton(
                        //add profile photo button
                        elevation: 0,
                        height: 35.0,
                        minWidth: 70.0,
                        color: const Color(0xFFFF1BC6),

                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0)),
                        textColor: Colors.white,
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String token = prefs.getString('token');
                          setState(() {
                            _progressVisibility = true;
                          });
                          var feeddata = await service.postNewFeedVibe(
                              widget.allUrl, token, textController.text);
                          setState(() {
                            _progressVisibility = false;
                          });
                          //check here
                          //direct to home screen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => MainScreen(
                                      passbaseStatus: passbaseVerified,
                                      passbaseverified: true,
                                      wallpaperUrl: userDetails["data"][0]
                                          ["currentWallpaper"],
                                      homebuttonUrl: userDetails["data"][0]
                                          ["currentHomebutton"],
                                    )),
                            (Route<dynamic> route) => false,
                          );
                          //Navigator.of(context).pushAndRemoveUntil(
                          //MaterialPageRoute(
                          // builder: (BuildContext context) =>
                          //       MainScreen()),
                          // (Route<dynamic> route) => false,
                          // );
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SFProDisplay'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //SizedBox(width: 20.0),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 35.0,
                        child: (widget.profileData["data"][0]
                                    ["profile_picture"] ==
                                "")
                            ? CircleAvatar(
                                backgroundColor: Color(0xFFFD6CCA),
                                radius: 32.0,
                                child: Center(
                                    child: Image(
                                        image: AssetImage(
                                            'images/profilephoto2x.png'))),
                              )
                            : CircleAvatar(
                                radius: 31.0,
                                backgroundColor: Color(0xFFFD6CCA),
                                backgroundImage: NetworkImage(
                                    "${widget.profileData["data"][0]["profile_picture"]}"),
                              ),
                      ),
                      SizedBox(width: 80.0, height: 20.0),
                      SizedBox(
                        width: 170.0,
                        height: 100,
                        child: VideoViewer(),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.0, height: 40.0),
                  Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: textController,
                        keyboardType: TextInputType.text,
                        cursorColor: const Color(0xFFFF1BC6),
                        decoration: InputDecoration(
                          hintText: 'Write a caption….',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'SFProDisplay',
                              color: Colors.white),
                          fillColor: Colors.transparent,
                          filled: true,
                          focusColor: const Color(0x66FFFFFF),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
