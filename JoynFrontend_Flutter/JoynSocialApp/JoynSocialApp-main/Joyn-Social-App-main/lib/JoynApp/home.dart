import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/AuthServices/postItemServices.dart';
import 'package:joyn_social_app/JoynApp/AddPost/post_feed_pic.dart';
import 'package:joyn_social_app/JoynApp/Customisation/CustomisationPage.dart';
import 'package:joyn_social_app/JoynApp/Story/models/story_model.dart';
import 'package:joyn_social_app/JoynApp/Story/storyFullPageView.dart';
import 'package:joyn_social_app/JoynApp/preferences.dart';
import 'package:joyn_social_app/JoynApp/widgets/feed_jot.dart';
import 'package:joyn_social_app/JoynApp/widgets/post_items.dart';
import 'package:joyn_social_app/passbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'AddPost/post_jot.dart';
import 'AddPost/trimmerviewvibe.dart';
import 'package:story_view/story_view.dart';
import 'Story/storyui.dart';

class Home extends StatefulWidget {
  final String wallpaperUrl;
  final String homeButtonUrl;
  final bool passbaseVerified;
  final String passbaseStatus;

  Home({
    Key key,
    this.wallpaperUrl,
    this.homeButtonUrl,
    this.passbaseVerified,
    this.passbaseStatus,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class ProjectModel {
  String id;
  String createdOn;
  String lastModifiedOn;
  String title;
  String description;

  ProjectModel({
    this.id,
    this.createdOn,
    this.lastModifiedOn,
    this.title,
    this.description,
  });
}

class _HomeState extends State<Home> {
  bool _visible = false;
  bool showBottomMenu = false;
  AuthServices service = new AuthServices();
  JoynTokenServices services = new JoynTokenServices();
  ItemServices itemservices = new ItemServices();
  List reverseUserDetails;
  List userdetails;
  List vibedetails;
  List reverseVibeDetails;
  List vibesData = [];
  final Trimmer _trimmer = Trimmer();
  String fileName;
  List<PlatformFile> _paths;
  List<Story> stories = [];
  String directoryPath;
  String extension;
  bool loadingPath = false;
  bool multiPick = false;
  FileType pickingType = FileType.any;
  final formKey = GlobalKey<FormState>();
  String username;
  String profilepic;
  bool islatestSelected = false;
  bool ispopolarSelected = false;
  String currentWallpaper, currentHomebutton;
  var status;
  var accountinfo;
  var popularpostslist;
  var latestpostslist;
  var vibes;
  String feedtype = "default";
  bool vibesLoaded = false;
  bool feedsLoaded = false;
  bool posted = false;
  var result;
  final storyController = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      //backgroundColor: const Color(0x60373169),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF09091F),
        title: ImageIcon(
          AssetImage('images/joynimage.png'),
          //color: Colors.white,
          size: 70,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Image.asset(
              "images/tokenbutton.png",
              height: 30,
              width: 33,

              filterQuality: FilterQuality.high,
              //fit: BoxFit.contain,
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String token = prefs.getString('token');
              String username = prefs.getString('userName');
              var result = await services.accountInfo(token, username);
              print(result["data"]["user"]["token"]);

              showDialog(
                // useSafeArea: false,

                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFF09091F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    insetPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 50),
                    content: Stack(
                      //alignment: AlignmentDirectional.topCenter,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -30.0,
                          top: -30.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Container(
                              //height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('images/background2x.png'),
                                ),
                              ),

                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Your balance',
                                      style: TextStyle(
                                          fontSize: 21.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'VAG'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          result["data"]["user"]["token"]
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 21.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontFamily: 'VAG'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Image.asset(
                                          "images/tokenbutton.png",
                                          height: 30,
                                          width: 33,

                                          filterQuality: FilterQuality.high,
                                          //fit: BoxFit.contain,
                                        ),
                                        // IconButton(
                                        //   icon: Icon(Icons.ac_unit),
                                        //   onPressed: () async {
                                        //     var addToken = await services
                                        //         .addToken(username);
                                        //     print(addToken);
                                        //   },
                                        // )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: Text(
                                'Recent Rewards',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'VAG'),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Image.asset(
                            'images/profilephotoverify.png',
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 10,
                          child: MaterialButton(
                            // elevation: 0,
                            // height: 35.0,
                            // minWidth: 70.0,
                            color: const Color(0xFFFF1BC6),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0)),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Preferences()),
                              );
                            },
                            child: Text(
                              'Edit Preferences',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'SFProDisplay'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.wallpaperUrl == "" || widget.wallpaperUrl == null
                ? AssetImage("images/background3x.png")
                : NetworkImage(widget.wallpaperUrl),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: vibesLoaded == true
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vibes["data"].length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StoryFullPageView(
                                                  stories: stories,
                                                  selectedIndex: index))),
                                  child: StoryUI(
                                    dp: vibes["data"][index]["profile_picture"],
                                    name: vibes["data"][index]["username"],
                                  ),
                                );
                              })
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                  ],
                ),
              ),
            ),
            feedsLoaded
                ? Flexible(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: reverseUserDetails.length,
                      itemBuilder: (context, index) {
                        if (reverseUserDetails[index]["type"] == "Jot") {
                          print(
                              "MEDIA URL - ${reverseUserDetails[index]["media_url"]}");
                          return Column(
                            children: <Widget>[
                              FeedJot(
                                media: reverseUserDetails[index]["media_url"],
                                description: reverseUserDetails[index]
                                    ["description"],
                                dp: reverseUserDetails[index]
                                    ["profile_picture"],
                                name: reverseUserDetails[index]["username"],
                                time: reverseUserDetails[index]["timestamp"],
                                likes: reverseUserDetails[index]["likes"],
                                likeDetails: reverseUserDetails[index]
                                    ["like_details"],
                                postid: reverseUserDetails[index]["_id"],
                                followList: accountinfo["data"]["user"]
                                    ["following"],
                                email: reverseUserDetails[index]["email"],
                              )
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              PostItem(
                                media: reverseUserDetails[index]["media_url"],
                                description: reverseUserDetails[index]
                                    ["description"],
                                dp: reverseUserDetails[index]
                                    ["profile_picture"],
                                name: reverseUserDetails[index]["username"],
                                time: reverseUserDetails[index]["timestamp"],
                                likes: reverseUserDetails[index]["likes"],
                                likeDetails: reverseUserDetails[index]
                                    ["like_details"],
                                postid: reverseUserDetails[index]["_id"],
                                followList: accountinfo["data"]["user"]
                                    ["following"],
                                email: reverseUserDetails[index]["email"],
                              )
                            ],
                          );
                        }
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
      floatingActionButton: widget.passbaseVerified
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFFF1BC6),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                _onButtonPressed();
                setState(() {
                  _visible = true;
                });
              },
            )
          : null,
    );
  }

  Future<void> navigationTapped() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('userName');
    profilepic = prefs.getString('profilepic');
  }

  @override
  void initState() {
    super.initState();
    this.getAllVibes();
    this.getProjectDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget projectWidget() {
    feedsLoaded
        ? ListView.builder(
            itemCount: reverseUserDetails.length,
            itemBuilder: (context, index) {
              if (reverseUserDetails[index]["type"] == "Jot") {
                return Column(
                  children: <Widget>[
                    FeedJot(
                      media: reverseUserDetails[index]["media_url"],
                      description: reverseUserDetails[index]["description"],
                      dp: reverseUserDetails[index]["profile_picture"],
                      name: reverseUserDetails[index]["username"],
                      time: reverseUserDetails[index]["timestamp"],
                      likes: reverseUserDetails[index]["likes"],
                      likeDetails: reverseUserDetails[index]["like_details"],
                      postid: reverseUserDetails[index]["_id"],
                      followList: accountinfo["data"]["user"]["following"],
                      email: reverseUserDetails[index]["email"],
                    )
                  ],
                );
              } else {
                //if (reverseUserDetails[index]["type"] == "Pic")
                return Column(
                  children: <Widget>[
                    PostItem(
                      media: reverseUserDetails[index]["media_url"],
                      description: reverseUserDetails[index]["description"],
                      dp: reverseUserDetails[index]["profile_picture"],
                      name: reverseUserDetails[index]["username"],
                      time: reverseUserDetails[index]["timestamp"],
                      likes: reverseUserDetails[index]["likes"],
                      likeDetails: reverseUserDetails[index]["like_details"],
                      postid: reverseUserDetails[index]["_id"],
                      followList: accountinfo["data"]["user"]["following"],
                      email: reverseUserDetails[index]["email"],
                    )
                  ],
                );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
    return Container();
  }

  Future getProjectDetails() async {
    var result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String username = prefs.getString('userName');
    print(username);

    accountinfo = await services.accountInfo(token, username);
    if (feedtype == "default" || feedtype == "latest") {
      result = await service.feedDetails(token);
      userdetails = result["data"];
    } else if (feedtype == "popular") {
      popularpostslist = await itemservices.getPopularPosts(token);
      userdetails = popularpostslist["data"];
    }
    setState(() {
      reverseUserDetails = userdetails.reversed.toList();
      feedsLoaded = true;
    });
    return reverseUserDetails;
  }

  Future getAllVibes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String username1 = prefs.getString('userName');

    vibes = await service.getAllVibes(token);

    setState(() {
      if (vibes != null) {
        vibesData = vibes["data"];
        vibesData.sort((a, b) => a["username"].compareTo(b["username"]));
        for (var vibe in vibesData) {
          String temp = vibe["media_url"][0]["type"].toString();
          MediaType mediaType;
          if (temp.substring(0, temp.indexOf("/")) == "video")
            mediaType = MediaType.video;
          else
            mediaType = MediaType.image;
          stories.add(Story(
              url: vibe["media_url"][0]["url"],
              media: mediaType,
              duration: Duration(seconds: 15)));
        }
      }
    });
    setState(() {
      vibesLoaded = true;
    });
    for (int i = 0; i < vibes["data"].length; i++) {
      if (vibes["data"][i]["username"] == username1) {
        posted = true;
      } else {
        posted = false;
      }
      String temp = vibes["data"][0]["media_url"][0]["type"].toString();
      print("VIBES DATA - " + temp.substring(0, temp.indexOf("/")));
    }

    for (int i = 0; i < vibes["data"].length; i++) {
      reverseVibeDetails[i] = vibes["data"][i]["profile_picture"];
    }
    print(reverseVibeDetails);

    return vibes["data"];
  }

  Future _openFileExplorer() async {
    setState(() => loadingPath = true);
    try {
      directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'mp4', 'gif'],
      ))
          ?.files;
      return _paths;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      loadingPath = false;
      fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF09091F),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.only(left: 20, right: 20, top: 0),

          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feed Controls',
                            style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontFamily: 'VAG'),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'Sort by',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontFamily: 'VAG'),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white30,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String token = prefs.getString('token');
                            setState(() {
                              ispopolarSelected = false;
                              islatestSelected = true;
                              feedtype = "latest";
                            });
                            Navigator.pop(context);
                            result = await service.feedDetails(token);
                            userdetails = result["data"];
                            setState(() {
                              reverseUserDetails =
                                  userdetails.reversed.toList();
                              feedsLoaded = true;
                            });
                            // setState(() {
                            //   ispopolarSelected = false;
                            //   islatestSelected = true;
                            //   feedtype = "latest";
                            // });

                            // await getProjectDetails().then(
                            //   (value) => Navigator.pop(context),
                            // );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3.2,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: islatestSelected
                                  ? Colors.black54
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                'Latest',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'VAG'),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String token = prefs.getString('token');
                            setState(() {
                              ispopolarSelected = false;
                              islatestSelected = true;
                              feedtype = "popular";
                            });
                            Navigator.pop(context);
                            popularpostslist =
                                await itemservices.getPopularPosts(token);
                            userdetails = popularpostslist["data"];
                            setState(() {
                              reverseUserDetails =
                                  userdetails.reversed.toList();
                              feedsLoaded = true;
                            });
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // String token = prefs.getString('token');

                            // var popularpostslist =
                            //     await itemservices.getPopularPosts(token);
                            // print(popularpostslist);
                            // setState(() {
                            //   ispopolarSelected = true;
                            //   islatestSelected = false;
                            //   //reverseUserDetails = popularpostslist["data"];
                            //   feedtype = "popular";
                            // });
                            // await getProjectDetails().then(
                            //   (value) => Navigator.pop(context),
                            // );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3.2,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ispopolarSelected
                                  ? Colors.black54
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'VAG'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Customisations',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.pink,
                  fontFamily: 'VAG'),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "images/tokenbutton.png",
                  height: 20,
                  width: 20,

                  filterQuality: FilterQuality.high,
                  //fit: BoxFit.contain,
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => widget.passbaseVerified
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomisationPage()),
                        )
                      : null,
                  child: Text(
                    'Customisation Shop',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: widget.passbaseVerified
                            ? Colors.white
                            : Colors.white10,
                        fontFamily: 'VAG'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Verification Status',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.pink,
                  fontFamily: 'VAG'),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SizedBox(
                //   width: 15,
                // ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.pink,
                  size: 20,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  widget.passbaseStatus,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: 'VAG'),
                ),
                SizedBox(
                  width: 20,
                ),
                new Spacer(),
                Container(
                  height: 25,
                  child: widget.passbaseStatus == 'Not Completed' ||
                          widget.passbaseStatus == 'declined'
                      ? MaterialButton(
                          color: Colors.white12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.pink),
                          ),
                          height: 30,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PassbaseDemoHomePage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            "Verify",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontFamily: 'VAG'),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              ),
            ),
            //color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Flexible(
              child: Container(
                child: _buildBottomNavigationMenu(),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        Flexible(
          child: SizedBox(
            height: 8,
          ),
        ),
        Container(
          height: 5,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Publish",
          style: TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'VAG'),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: SizedBox(
            height: 88,
            width: MediaQuery.of(context).size.width * .75,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 1),
              color: const Color(0xFF373169),
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Positioned(
                      child: CircleAvatar(
                        child: Image.asset(
                          'images/msg.png',
                          filterQuality: FilterQuality.high,
                        ),
                        radius: 46,
                        backgroundColor: Color(0xFF01DBFF),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Jot",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'VAG'),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Up to 240 characters",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontFamily: 'VAG'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token');
                String email = prefs.getString('emailValue');
                var userData = await service.userDetails(token, email);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostJot(profileData: userData),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0, right: 12),
          child: SizedBox(
            height: 88,
            width: MediaQuery.of(context).size.width * .75,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 1),
              color: const Color(0xFF373169),
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Positioned(
                      child: CircleAvatar(
                        child: Image.asset(
                          'images/pic.png',
                          filterQuality: FilterQuality.high,
                        ),
                        radius: 46,
                        backgroundColor: Color(0xFFE227FF),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Pic",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'VAG'),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Photos in a carousel",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              fontFamily: 'VAG'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token');
                String email = prefs.getString('emailValue');
                try {
                  var data = await _openFileExplorer().then((value) {
                    if (value == null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarouselDemo(
                            media: value,
                          ),
                        ),
                      );
                    }
                  });
                  print(data);
                  print(data[0].path);
                } catch (ex) {
                  print(ex);
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.only(left: 12.0, right: 12),
          child: SizedBox(
            height: 88,
            width: MediaQuery.of(context).size.width * .75,
            child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 1),
                color: const Color(0xFF373169),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Image.asset(
                          'images/video.png',
                          filterQuality: FilterQuality.high,
                        ),
                        radius: 46,
                        backgroundColor: Color(0xFFFF1BC6),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Vibe",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'VAG'),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "15 second videos",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                color: Colors.white,
                                fontFamily: 'VAG'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // onPressed: () async {
                //   //   // if (posted == true) {
                //   //   //   showToast();
                //   //   // } else {

                //   //   File file = await ImagePicker.pickVideo(
                //   //     source: ImageSource.gallery,
                //   //   );
                //   //   print(file.path);
                //   //   if (file != null) {
                //   //     await _trimmer.loadVideo(videoFile: File(file.path));
                //   //     Navigator.of(context).push(
                //   //       MaterialPageRoute(
                //   //         builder: (context) => TrimmerViewVibe(_trimmer),
                //   //       ),
                //   //     );
                //   //   }

                //   //   // try {
                //   //   //   var data = await _openVideoFile().then((value) async {
                //   //   //     if (value == null) {
                //   //   //       Navigator.pop(context);
                //   //   //     } else {
                //   //   //       await _trimmer.loadVideo(videoFile: File(value[0].path));
                //   //   //       print(_trimmer);
                //   //   //       print(value[0].path);
                //   //   //       final result = await Navigator.of(context).push(
                //   //   //         MaterialPageRoute(
                //   //   //           builder: (context) {
                //   //   //             return TrimmerViewVibe(_trimmer);
                //   //   //           },
                //   //   //         ),
                //   //   //       );
                //   //   //       // Navigator.push(
                //   //   //       //   context,
                //   //   //       //   MaterialPageRoute(
                //   //   //       //     builder: (context) => CarouselDemo(
                //   //   //       //       media: value,
                //   //   //       //     ),
                //   //   //       //   ),
                //   //   //       // );
                //   //   //     }
                //   //   //   });
                //   //   //   print(data);
                //   //   //   print(data[0].path);
                //   //   // } catch (ex) {
                //   //   //   print(ex);
                //   //   // }
                //   // /*  if(posted == true){
                //   //     showToast();
                //   //   } */
                //   File file = await ImagePicker.pickVideo(
                //     source: ImageSource.gallery,
                //   );
                //   print(file.path);
                //   if (file != null) {
                //     await _trimmer.loadVideo(videoFile: file);
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return TrimmerViewVibe(_trimmer);
                //         },
                //       ),
                //     );
                onPressed: () async {
                  // if(posted == true){
                  //   showToast();
                  // }
                  // else {
                  // final pickedFile =
                  //     await ImagePicker().getImage(source: ImageSource.gallery);
                  // File file = File(pickedFile.path);
                  File file = await ImagePicker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  print(file.path);
                  if (file != null) {
                    await _trimmer.loadVideo(videoFile: file);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return TrimmerViewVibe(_trimmer);
                        },
                      ),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
