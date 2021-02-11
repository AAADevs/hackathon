import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/AuthServices/postItemServices.dart';
import 'package:joyn_social_app/JoynApp/AddPost/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile.dart';
import '../userProfilePage.dart';

class FeedJot extends StatefulWidget {
  final bool height;
  final media;
  final String description;
  final String dp;
  final String name;
  final String time;
  final String mediatype;
  final String mediaurl;
  final String postid;
  final likeDetails;
  final followList;
  final email;
  int likes;

  FeedJot({
    Key key,
    this.media,
    this.height,
    this.description,
    this.mediaurl,
    this.dp,
    this.name,
    this.time,
    this.mediatype,
    this.postid,
    this.likeDetails,
    this.followList,
    this.likes,
    this.email,
  }) : super(key: key);
  @override
  _FeedJotState createState() => _FeedJotState();
}

class _FeedJotState extends State<FeedJot> {
  bool isvideo = false;
  int _current = 0;
  bool liked = false;
  bool _visible = false;
  bool tippingdone = false;
  var userdetails;
  JoynTokenServices services = new JoynTokenServices();
  AuthServices authservice = new AuthServices();
  ItemServices service = new ItemServices();

  @override
  void initState() {
    super.initState();
    this.checkpostlike();
  }

  checkpostlike() async {
    for (int i = 0; i < widget.likeDetails.length; i++) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('userName');

      if (widget.likeDetails[i]["username"] == username) {
        setState(() {
          liked = true;
        });
      } else {
        setState(() {
          liked = false;
        });
      }
    }
  }

  void _showMaterialDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 24,
          backgroundColor: const Color(0xFF09091F),
          title: Center(
            child: Text(
              "Likes",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 25.0,
                  fontFamily: 'VAG',
                  color: Colors.white),
            ),
          ),
          content: setupAlertDialoadContainer(widget.likeDetails),
        );
      },
    );
  }

  Widget setupAlertDialoadContainer(final likedetails) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: likedetails.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              "@" + likedetails[index]["username"],
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontFamily: 'VAG',
                  color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getUserDetails(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String username = prefs.getString('userName');
    String token = prefs.getString('token');

    userdetails = await authservice.userDetails(token, email);
    print(userdetails["data"][0]["_id"]);
    //checkFollower(userdetails["data"]["user"]["_id"]);
    return userdetails;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: InkWell(
        child: Container(
          height: widget.height == true ? 600 : null,
          decoration: BoxDecoration(
            color: const Color(0xFF09091F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ListTile(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    String accountID = prefs.getString('accountID');
                    // checkFollower()
                    await getUserDetails(widget.email);
                    if (userdetails["data"][0]["_id"] == accountID) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            profilepic: widget.dp,
                            username: widget.name,
                          ),
                        ),
                      );
                    } else
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            userfromSearchResult: false,
                            profilepic: widget.dp,
                            username: widget.name,
                            followlist: widget.followList,
                            userid: userdetails["data"][0]["_id"],
                          ),
                        ),
                      );
                  },
                  leading: CircleAvatar(
                    onBackgroundImageError: (exception, stackTrace) {
                      return CircleAvatar(
                        //backgroundColor: Color(0xFFFD6CCA),
                        radius: 47.0,
                        child: Center(
                          child: Image(
                            image: AssetImage('images/profilephoto2x.png'),
                          ),
                        ),
                      );
                    },
                    backgroundImage: NetworkImage(
                      widget.dp,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "${widget.name}",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        fontFamily: 'VAG',
                        color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  subtitle: Text(
                    "${widget.time}",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 11.0,
                        fontFamily: 'VAG',
                        color: Colors.white54),
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Flexible(
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                fontFamily: 'SFProDisplay',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CarouselSlider.builder(
                          // height: 170,
                          // aspectRatio: 2.0,
                          // enlargeCenterPage: true,
                          //
                          // // initialPage: 0,
                          // viewportFraction: 0.4,

                          // autoPlay: false,
                          // reverse: false,
                          enableInfiniteScroll: false,
                          // autoPlayInterval: Duration(seconds: 2),
                          // autoPlayAnimationDuration: Duration(milliseconds: 2000),
                          // pauseAutoPlayOnTouch: Duration(seconds: 10),
                          // scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                          itemCount: widget.media.length,
                          itemBuilder: (BuildContext context, int itemIndex) {
                            int j = widget.media[itemIndex]["originalname"]
                                .lastIndexOf('.');
                            if (widget.media[itemIndex]["type"] ==
                                    "image/jpeg" ||
                                widget.media[itemIndex]["type"] ==
                                    "image/jpg" ||
                                widget.media[itemIndex]["type"] ==
                                    "image/png") {
                              return GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(8),
                                  child: Image.network(
                                    widget.media[itemIndex]["url"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) {
                                      return DetailScreen(
                                        image: widget.media[itemIndex]["url"],
                                      );
                                    }),
                                  );
                                },
                              );
                            } else {
                              return Container(
                                padding: EdgeInsets.all(8),
                                child: Video_Player(
                                  video: widget.media[itemIndex]["url"],
                                  videotype: widget.media[itemIndex]["type"],
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: map<Widget>(widget.media, (index, url) {
                            return Container(
                              width: 10.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.white
                                    : Colors.white10,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 45,
                    right: 15, //give the values according to your requirement
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Container(
                        padding: EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: const Color(0xFF09091F),
                        ),
                        width: 220.0,
                        height: 90.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Tip this post",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 19.0,
                                  fontFamily: 'VAG',
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Container(
                              child: tippingdone
                                  ? Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(13),
                                        ),
                                        color: Colors.black54,
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Thanks!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18.0,
                                                  fontFamily: 'VAG',
                                                  color: Colors.pink),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 20,
                                              child: Image.asset(
                                                "images/Likebutton1.png",
                                                fit: BoxFit.contain,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipOval(
                                          child: Material(
                                            color:
                                                Colors.white24, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.red, // inkwell color
                                              child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "5",
                                                      style: TextStyle(
                                                          fontSize: 19.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontFamily: 'VAG'),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Image.asset(
                                                      "images/tokenbutton.png",
                                                      height: 25,
                                                      width: 25,

                                                      filterQuality:
                                                          FilterQuality.high,
                                                      //fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String token =
                                                    prefs.getString('token');
                                                String username =
                                                    prefs.getString('userName');

                                                setState(() {
                                                  tippingdone = true;
                                                });
                                                var result = await services
                                                    .transferTokentoUser(
                                                        token,
                                                        username,
                                                        widget.name,
                                                        "5");
                                                print(result);
                                                setState(() {
                                                  _visible = !_visible;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            color:
                                                Colors.white24, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.red, // inkwell color
                                              child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "10",
                                                      style: TextStyle(
                                                          fontSize: 19.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontFamily: 'VAG'),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Image.asset(
                                                      "images/tokenbutton.png",
                                                      height: 25,
                                                      width: 25,

                                                      filterQuality:
                                                          FilterQuality.high,
                                                      //fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String token =
                                                    prefs.getString('token');
                                                String username =
                                                    prefs.getString('userName');

                                                setState(() {
                                                  tippingdone = true;
                                                });
                                                var result = await services
                                                    .transferTokentoUser(
                                                        token,
                                                        username,
                                                        widget.name,
                                                        "10");
                                                setState(() {
                                                  _visible = !_visible;
                                                });
                                                print(result);
                                              },
                                            ),
                                          ),
                                        ),
                                        ClipOval(
                                          child: Material(
                                            color:
                                                Colors.white24, // button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.red, // inkwell color
                                              child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "20",
                                                      style: TextStyle(
                                                          fontSize: 19.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.white,
                                                          fontFamily: 'VAG'),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Image.asset(
                                                      "images/tokenbutton.png",
                                                      height: 25,
                                                      width: 25,

                                                      filterQuality:
                                                          FilterQuality.high,
                                                      //fit: BoxFit.contain,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String token =
                                                    prefs.getString('token');
                                                String username =
                                                    prefs.getString('userName');

                                                setState(() {
                                                  tippingdone = true;
                                                });
                                                var result = await services
                                                    .transferTokentoUser(
                                                        token,
                                                        username,
                                                        widget.name,
                                                        "20");
                                                setState(() {
                                                  _visible = !_visible;
                                                });
                                                print(result);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      alignment: Alignment.bottomLeft, iconSize: 35,
                      icon: liked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.pink,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                      // ImageIcon(
                      //   AssetImage('images/likebutton.png'),
                      //   color: Colors.green,
                      // ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String token = prefs.getString('token');
                        if (liked) {
                          var response =
                              await service.unlikePost(token, widget.postid);
                          print(response);

                          setState(() {
                            liked = false;
                            widget.likes -= 1;
                          });
                        } else {
                          var response =
                              await service.likePost(token, widget.postid);
                          print(response);

                          setState(() {
                            liked = true;
                            widget.likes += 1;
                          });
                        }
                      },
                    ),
                    InkWell(
                      child: Text(
                        widget.likes.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          fontFamily: 'vag',
                          color: Colors.white54,
                        ),
                      ),
                      onTap: () {
                        _showMaterialDialog();
                      },
                    ),
                    new Spacer(),
                    IconButton(
                      icon: new Image.asset(
                        "images/tokenbutton.png",
                        height: 30,
                        width: 28,

                        filterQuality: FilterQuality.high,
                        //fit: BoxFit.contain,
                      ),
                      onPressed: () async {
                        setState(() {
                          _visible = !_visible;
                          tippingdone = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final image;

  DetailScreen({
    this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              image,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
