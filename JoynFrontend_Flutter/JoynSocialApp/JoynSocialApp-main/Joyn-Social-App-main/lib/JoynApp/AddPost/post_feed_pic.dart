import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/AddPost/video_player.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

import 'videoEditor.dart';

class CarouselDemo extends StatefulWidget {
  final media;

  CarouselDemo({
    Key key,
    this.media,
  }) : super(key: key);

  @override
  CarouselDemoState createState() => CarouselDemoState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class CarouselDemoState extends State<CarouselDemo> {
  final Trimmer _trimmer = Trimmer();
  bool ratio = false;
  bool imageChanged = false;
  CarouselSlider carouselSlider;
  int _current = 0;
  List<dynamic> allUrls = [];
  AppState state;
  File tempFile;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  AuthServices service = new AuthServices();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool videotrimmed = false;

  Future<String> _saveVideo(Trimmer _trimmer) async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await _trimmer
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
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    this.addAllUrls();
  }

  @override
  void dispose() {
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  addAllUrls() {
    int length = widget.media.length;
    for (int i = 0; i < length; i++) {
      allUrls.add(widget.media[i].path);
    }
  }

  Future<String> _cropImage(String image, int index) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image,
        aspectRatioPresets: Platform.isAndroid
            ? [
                // CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x5,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    // if (croppedFile != null) {
    //   //image = croppedFile;
    //   setState(() {
    //     widget.media.removeAt(index);
    //     widget.media.insert(index, croppedFile);
    //     //imageChanged = true;
    //     //_imagewidget(croppedFile.path);

    //     //_imageWidget = Image.file(croppedFile);
    //   });
    //   // setState(() {
    //   //   state = AppState.cropped;
    //   // });
    // }
    return croppedFile.path;
  }

  Future loadvideo() async {
    print("loaded");
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
    return Scaffold(
      backgroundColor: const Color(0xFF09091F),
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
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token');
                String email = prefs.getString('emailValue');
                var userData = await service.userDetails(token, email);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostFeed(
                      profileData: userData,
                      platformFiles: widget.media,
                      allUrls: allUrls,
                    ),
                  ),
                );
                // print('OUTPUT PATH: $outputPath');
                // final snackBar = SnackBar(
                //     content: Text('Video Saved successfully'));
                // Scaffold.of(context).showSnackBar(snackBar);
              },
              child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 22.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'VAG'),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            carouselSlider = CarouselSlider.builder(
              height: 500,
              initialPage: 0,

              //enlargeCenterPage: true,
              viewportFraction: 1.0,
              autoPlay: false,
              reverse: false,
              enableInfiniteScroll: false,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              itemCount: widget.media.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                if (widget.media[itemIndex].extension == "jpg" ||
                    widget.media[itemIndex].extension == "jpeg") {
                  // _imageWidget = Image.file(
                  //   new File(widget.media[itemIndex].path),
                  //   fit: BoxFit.cover,
                  //   //key: UniqueKey(),
                  // );

                  return Card(
                    color: Colors.black,
                    elevation: 3.0,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: AspectRatio(
                            aspectRatio: 4 / 5,
                            child: Image.file(
                              new File(allUrls[itemIndex]),
                              //cacheHeight: 5,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            splashColor: Colors.black87,
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue[900],
                            ),
                            onPressed: () async {
                              // var newFile = await _cropImage(
                              //     widget.media[itemIndex].path, itemIndex);
                              // // PlatformFile file = new PlatformFile(
                              // //     path: newFile.path,
                              // //     name: widget.media[itemIndex].name,
                              // //     size: widget.media[itemIndex].size);
                              // setState(() {
                              //   if (newFile != null) {
                              //     widget.media[itemIndex].path = newFile.path;
                              //   }
                              // });
                              String croppedUrl = await _cropImage(
                                  allUrls[itemIndex], itemIndex);
                              //tempFile = File(file.path);
                              if (croppedUrl != null) {
                                setState(() {
                                  allUrls[itemIndex] = croppedUrl;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                } else if (widget.media[itemIndex].extension == "mp4") {
                  //tempFile = File(allUrls[itemIndex]);

                  // setState(() {
                  //   _trimmer.loadVideo(videoFile: tempFile);
                  // });

                  return Card(
                    color: Colors.black,
                    elevation: 3.0,
                    child: Stack(
                      children: <Widget>[
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: IconButton(
                        //     splashColor: Colors.black87,
                        //     icon: Icon(
                        //       Icons.save_alt,
                        //       color: Colors.blue[900],
                        //     ),
                        //     onPressed: _progressVisibility
                        //         ? null
                        //         : () async {
                        //             SharedPreferences prefs =
                        //                 await SharedPreferences.getInstance();
                        //             String token = prefs.getString('token');
                        //             String email =
                        //                 prefs.getString('emailValue');
                        //             var userData =
                        //                 await service.userDetails(email, token);

                        //             var data = await _saveVideo(_trimmer)
                        //                 .then((outputPath) {
                        //               setState(() {
                        //                 allUrls[itemIndex] = outputPath;
                        //               });
                        //             });
                        //           },
                        //   ),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(bottom: 30.0),
                        //   color: Colors.black,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: <Widget>[
                        //       Visibility(
                        //         visible: _progressVisibility,
                        //         child: LinearProgressIndicator(
                        //           backgroundColor: Colors.red,
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: VideoViewer(),
                        //       ),
                        //       Center(
                        //         child: TrimEditor(
                        //           viewerHeight: 50.0,
                        //           viewerWidth:
                        //               MediaQuery.of(context).size.width,
                        //           onChangeStart: (value) {
                        //             _startValue = value;
                        //           },
                        //           onChangeEnd: (value) {
                        //             _endValue = value;
                        //           },
                        //           maxVideoLength: Duration(seconds: 15),
                        //           showDuration: true,
                        //           onChangePlaybackState: (value) {
                        //             setState(() {
                        //               _isPlaying = value;
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //       FlatButton(
                        //         child: _isPlaying
                        //             ? Icon(
                        //                 Icons.pause,
                        //                 size: 80.0,
                        //                 color: Colors.white,
                        //               )
                        //             : Icon(
                        //                 Icons.play_arrow,
                        //                 size: 80.0,
                        //                 color: Colors.white,
                        //               ),
                        //         onPressed: () async {
                        //           bool playbackState =
                        //               await _trimmer.videPlaybackControl(
                        //             startValue: _startValue,
                        //             endValue: _endValue,
                        //           );
                        //           setState(() {
                        //             _isPlaying = playbackState;
                        //           });
                        //         },
                        //       )
                        //     ],
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Video_Player(
                              video: File(allUrls[itemIndex]),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            splashColor: Colors.black87,
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue[900],
                            ),
                            onPressed: () async {
                              await _trimmer.loadVideo(
                                  videoFile: File(allUrls[itemIndex]));
                              //var data = TrimmerView(_trimmer);

                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TrimmerView(_trimmer);
                                  },
                                ),
                              );
                              setState(() {
                                if (result != null) {
                                  allUrls[itemIndex] = result;
                                }

                                //tempFile = File(result);
                                print("===========" + allUrls.toString());
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            // initializePlayer(tempFile).then(
            //   (value) => AspectRatio(
            //     aspectRatio: _videoPlayerController2.value.aspectRatio,
            //     child: Center(
            //       child: _chewieController != null &&
            //               _chewieController
            //                   .videoPlayerController.value.initialized
            //           ? Chewie(
            //               controller: _chewieController,
            //             )
            //           : Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 CircularProgressIndicator(),
            //                 SizedBox(height: 20),
            //                 Text('Loading'),
            //               ],
            //             ),
            //     ),
            //   ),
            // );

            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(widget.media, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.white : Colors.white10,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}

class BoxSelection {
  bool isSelected;
  String title;
  String options;
  BoxSelection({this.title, this.isSelected, this.options});
}

class PostFeed extends StatefulWidget {
  final profileData;
  final feedData;
  final platformFiles;
  final allUrls;
  final category;

  PostFeed({
    Key key,
    this.platformFiles,
    this.profileData,
    this.feedData,
    this.allUrls,
    this.category,
  }) : super(key: key);

  @override
  _PostFeed createState() => _PostFeed();
}

class _PostFeed extends State<PostFeed> {
  TextEditingController textController = new TextEditingController();
  List<dynamic> platformFiles = [];
  bool _progressVisibility = false;
  List<BoxSelection> projectType = new List();
  bool categoryList = false;
  String selectedValue;
  String passbaseVerified = "Verified";
  var getUserDetails;

  List<String> sortFilter = [
    'Others',
    'Funny',
    'Pets',
    'Arts',
    'Sports',
    'News',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    projectType
        .add(BoxSelection(title: "Building", isSelected: false, options: "A"));
    projectType
        .add(BoxSelection(title: "Gym House", isSelected: false, options: "B"));
    projectType
        .add(BoxSelection(title: "School", isSelected: false, options: "C"));
  }

  @override
  void initState() {
    super.initState();
    this.addAllUrls();
    selectedValue = sortFilter.first;
  }

  addAllUrls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('emailValue');
    String token = prefs.getString('token');

    getUserDetails = await service.userDetails(token, email);

    int length = widget.platformFiles.length;
    for (int i = 0; i < length; i++) {
      //File file = new File(widget.media[i]);
      platformFiles.add(widget.platformFiles[i]);
    }
  }

  String platformResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthServices service = new AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09091F),
        title: Text(
          'New Pic',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'VAG'),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: MaterialButton(
              //add profile photo button
              elevation: 0,
              height: 36.0,
              minWidth: 83.0,
              color: const Color(0xFFFF1BC6),

              shape: RoundedRectangleBorder(
                //side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50.0),
              ),
              textColor: Colors.white,
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString('token');
                if (textController.text == "") {
                  Fluttertoast.showToast(
                      msg: 'Enter Text',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xFF6B174E),
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else if (selectedValue == null) {
                  Fluttertoast.showToast(
                      msg: 'Select Category',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xFF6B174E),
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  setState(() {
                    _progressVisibility = true;
                  });
                  var feeddata = await service.postNewFeedPicVideo(
                      widget.allUrls,
                      platformFiles,
                      token,
                      textController.text,
                      selectedValue);

                  setState(() {
                    _progressVisibility = false;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(
                              passbaseStatus: passbaseVerified,
                              passbaseverified: true,
                              wallpaperUrl: getUserDetails["data"][0]
                                  ["currentWallpaper"],
                              homebuttonUrl: getUserDetails["data"][0]
                                  ["currentHomebutton"],
                            )),
                    (Route<dynamic> route) => false,
                  );
                }
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
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.transparent.withOpacity(0.52),
      body: Container(
        //to specify the background image
        constraints: BoxConstraints.expand(),
        color: Color(0xFF09091F),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("images/BkgGradientFeed.png"),
        //       fit: BoxFit.cover),
        // ),
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10.0),
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
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                      child: TextFormField(
                        // inputFormatters: [
                        //   new LengthLimitingTextInputFormatter(10),
                        // ],
                        maxLines: 4,
                        maxLength: 150,
                        style: TextStyle(color: Colors.white),
                        controller: textController,
                        keyboardType: TextInputType.text,
                        cursorColor: const Color(0xFFFF1BC6),
                        decoration: InputDecoration(
                          hintText: 'Write a caption…',
                          hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'VAG',
                              color: Colors.white30),
                          fillColor: Colors.transparent,
                          filled: true,
                          focusColor: const Color(0x66FFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.0, height: 30.0),
                Column(
                  children: [
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 700,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Category',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'VAG'),
                                ),
                                IconButton(
                                  icon: categoryList
                                      ? Icon(Icons.arrow_drop_down)
                                      : Icon(Icons.arrow_drop_up),
                                  iconSize: 25,
                                  color: Colors.white,
                                  splashRadius: 20,
                                  splashColor: Colors.white,
                                  hoverColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      categoryList = !categoryList;
                                    });
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              color: Colors.transparent,
                              child: categoryList
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (ctx, index) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            selectedValue = sortFilter[index];
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: selectedValue ==
                                                        sortFilter[index]
                                                    ? Colors.transparent
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  sortFilter[index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily:
                                                          'SFProDisplay'),
                                                ),
                                                Radio(
                                                  activeColor: Colors.green,
                                                  value: sortFilter[index],
                                                  groupValue: selectedValue,
                                                  onChanged: (s) {
                                                    selectedValue = s;
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: sortFilter.length,
                                    )
                                  : null,
                              height: MediaQuery.of(context).size.height / 2.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//             Listview with single selection

// class SingleSelectionExample extends StatefulWidget {
//   List<String> sortFilter;

//   SingleSelectionExample(this.sortFilter);

//   @override
//   _SingleSelectionExampleState createState() => _SingleSelectionExampleState();
// }

// class _SingleSelectionExampleState extends State<SingleSelectionExample> {
//   String selectedValue;

//   @override
//   void initState() {
//     super.initState();

//     selectedValue = widget.sortFilter.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.zero,
//       itemBuilder: (ctx, index) {
//         return GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () {
//             selectedValue = widget.sortFilter[index];
//             setState(() {
//               Navigator.push(
//                 context,
//                 new MaterialPageRoute(
//                   builder: (context) => new PostFeed(
//                     category: selectedValue,
//                   ),
//                 ),
//               );
//             });
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 color: selectedValue == widget.sortFilter[index]
//                     ? Colors.transparent
//                     : null,
//                 borderRadius: BorderRadius.circular(30)),
//             child: Row(
//               children: <Widget>[
//                 Text(
//                   widget.sortFilter[index],
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15.0,
//                       fontWeight: FontWeight.normal,
//                       fontFamily: 'SFProDisplay'),
//                 ),
//                 Radio(
//                   activeColor: Colors.green,
//                   value: widget.sortFilter[index],
//                   groupValue: selectedValue,
//                   onChanged: (s) {
//                     selectedValue = s;
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: widget.sortFilter.length,
//     );
//   }
// }
