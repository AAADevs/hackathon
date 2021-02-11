import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/widgets/post_items.dart';
import 'package:joyn_social_app/login.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'main_screen.dart';

class Profile extends StatefulWidget {
  final bool userfromSearchResult;
  final username;
  final profilepic;
  Profile({
    Key key,
    this.userfromSearchResult,
    this.username,
    this.profilepic,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isvideo = false;
  String profileurl = "";
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  AuthServices service = new AuthServices();
  List userdetails, reverseUserDetails;
  var getUserDetails;
  String passbase;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<Uint8List> getvideofile(String url) async {
    Uint8List bytes;
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    final file = File(uint8list);
    bytes = file.readAsBytesSync();
    return bytes;
  }

  initializePlayer(String url) async {
    _videoPlayerController2 = new VideoPlayerController.network(url);

    await _videoPlayerController2.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
      autoPlay: true,
      looping: true,
      //allowMuting: true,
      //aspectRatio: 16 / 9,
      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
    setState(() {});
  }

  _getImage(String videoPathUrl) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    final folderPath = appDocDir.path;
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: folderPath,
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 30);
    print("=========================" + thumb);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            String email = prefs.getString('emailValue');
            String token = prefs.getString('token');
            //Navigator.pop(context);
            getUserDetails = await service.userDetails(token, email);
            if (getUserDetails["data"][0]["passbase"] == false) {
              setState(() {
                passbase = "Not Completed";
              });
            } else {
              setState(() {
                passbase = "Verified";
              });
            }
            if (widget.userfromSearchResult) {
              Navigator.pop(context);
              //getUserDetails["data"][0]["passbase"] == false
            } else if (!widget.userfromSearchResult ||
                widget.userfromSearchResult == null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(
                    wallpaperUrl: getUserDetails["data"][0]["currentWallpaper"],
                    homebuttonUrl: getUserDetails["data"][0]
                        ["currentHomebutton"],
                    passbaseverified: getUserDetails["data"][0]["passbase"],
                    passbaseStatus: passbase,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        backgroundColor: const Color(0xFF09091F),
        // shape: RoundedRectangleBorder(

        //   borderRadius: BorderRadius.circular(18.0),
        // ),
        title: Text(
          "@" + widget.username,
          style: TextStyle(
              fontSize: 21.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'SFProDisplay'),
        ),
        centerTitle: true,

        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.more_horiz,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/ProfileGradientBkg3x.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: (widget.profilepic == "NA")
                          ? CircleAvatar(
                              //backgroundColor: Color(0xFFFD6CCA),
                              radius: 47.0,
                              child: Center(
                                  child: Image(
                                      image: AssetImage(
                                          'images/profilephoto2x.png'))),
                            )
                          : CircleAvatar(
                              radius: 47.0,
                              backgroundColor: Color(0xFFFD6CCA),
                              backgroundImage: NetworkImage(widget.profilepic),
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              color: Colors.white,
                              fontFamily: 'VAG'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "He/His",
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontFamily: 'SFProDisplay'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 22),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300].withOpacity(0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  height: 100.0,
                  //width: 311.0,
                  //color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'He/His. Co founder of @joyn 🍩 Trying to make the internet a better place.',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.grey,
                          fontFamily: 'SFProDisplay'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: IconButton(
                        splashColor: Colors.black,
                        icon: Icon(Icons.photo),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Colors.pink[200]),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      child: IconButton(
                        splashColor: Colors.black,
                        icon: Icon(Icons.message),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.pink[200],
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                      child: IconButton(
                        splashColor: Colors.black,
                        icon: Icon(Icons.videocam),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      // width: 300.0,
                      // height: 300.0,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.pink[200],
                        //shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Container(
                    //height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: FutureBuilder(
                      future: getPofileDetails(),
                      builder: (context, projectSnap) {
                        // if (projectSnap.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }
                        if (reverseUserDetails == null) {
                          return Container(
                            height: 100,
                            child: Center(
                              child: Text(
                                'No Feeds !',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontFamily: 'VAG'),
                              ),
                            ),
                          );
                        }

                        if (projectSnap.hasData) {
                          return SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              padding: EdgeInsets.all(5),
                              itemCount: reverseUserDetails.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 5,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                if (reverseUserDetails[index]["media_url"]
                                        .length ==
                                    0) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewGrid(
                                            //height: true,
                                            media: reverseUserDetails[index]
                                                ["media_url"],
                                            description:
                                                reverseUserDetails[index]
                                                    ["description"],
                                            dp: reverseUserDetails[index]
                                                ["profile_picture"],
                                            name: reverseUserDetails[index]
                                                ["username"],
                                            time: reverseUserDetails[index]
                                                ["timestamp"],
                                            // mediatype: reverseUserDetails[index]["media_url"][index]
                                            //     ["type"],
                                            // mediaurl: reverseUserDetails[index]["media_url"][index]
                                            //     ["url"],
                                            //img: reverseUserDetails[index]["media_url"][0],
                                            //video: reverseUserDetails[index]["media_url"][0],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        color: const Color(0xFF09091F),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              reverseUserDetails[index]
                                                  ["description"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.white30,
                                                  fontFamily: 'VAG'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (reverseUserDetails[index]
                                        ["media_url"][0]["type"] ==
                                    "video/mp4") {
                                  return FutureBuilder(
                                    future: getvideofile(
                                        reverseUserDetails[index]["media_url"]
                                            [0]["url"]),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        //print('project snapshot data is: ${projectSnap.data}');

                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewGrid(
                                                  //height: true,
                                                  media:
                                                      reverseUserDetails[index]
                                                          ["media_url"],
                                                  description:
                                                      reverseUserDetails[index]
                                                          ["description"],
                                                  dp: reverseUserDetails[index]
                                                      ["profile_picture"],
                                                  name:
                                                      reverseUserDetails[index]
                                                          ["username"],
                                                  time:
                                                      reverseUserDetails[index]
                                                          ["timestamp"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.memory(
                                              snapshot.data,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewGrid(
                                            //height: true,
                                            media: reverseUserDetails[index]
                                                ["media_url"],
                                            description:
                                                reverseUserDetails[index]
                                                    ["description"],
                                            dp: reverseUserDetails[index]
                                                ["profile_picture"],
                                            name: reverseUserDetails[index]
                                                ["username"],
                                            time: reverseUserDetails[index]
                                                ["timestamp"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        reverseUserDetails[index]["media_url"]
                                            [0]["url"],
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }
                        if (!projectSnap.hasData) {
                          return Column(
                            children: [
                              Container(
                                height: 1,
                                color: Colors.transparent,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Loading...',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontFamily: 'VAG'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                        if (!projectSnap.hasData) {
                          //print('project snapshot data is: ${projectSnap.data}');

                          return Column(
                            children: [
                              Container(
                                height: 1,
                                color: Colors.transparent,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'No feeds',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontFamily: 'VAG'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getPofileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var result = await service.profileDetails(token, widget.username);
    userdetails = result["data"];
    reverseUserDetails = userdetails.reversed.toList();
    setState(() {
      profileurl = reverseUserDetails[0]["profile_picture"];
    });

    return reverseUserDetails;
  }
}

class Videothumbnail extends StatefulWidget {
  final videourl;
  Videothumbnail({
    Key key,
    this.videourl,
  }) : super(key: key);
  @override
  Thumbnail createState() => Thumbnail();
}

class Thumbnail extends State<Videothumbnail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell();
  }
}
