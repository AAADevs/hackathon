import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/AddPost/Upload.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostJot extends StatefulWidget {
  final profileData;
  final media;

  PostJot({
    Key key,
    this.profileData,
    this.media,
  }) : super(key: key);
  @override
  _PostJot createState() => _PostJot();
}

class _PostJot extends State<PostJot> {
  // Map<String, String> _paths;
  // String _fileName;
  // String _path;
  // String _extension;
  // bool _loadingPath= false;
  // bool _multiPick = false;
  // FileType _pickingType;
  // String _directoryPath;
  bool categoryList = false;
  String selectedValue;

  List<String> sortFilter = [
    'Others',
    'Funny',
    'Pets',
    'Arts',
    'Sports',
    'News'
  ];
  bool _progressVisibility = false;
  TextEditingController textController = new TextEditingController();

  /*Future _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = await FilePicker.getMultiFile(type: FileType.media);
      List<String> allPaths = _paths.values;
      return allPaths[0];
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      //_fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }*/

  @override
  String platformResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    selectedValue = sortFilter.first;
  }

  AuthServices service = new AuthServices();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09091F),
        title: Text(
          'New Jot',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'VAG'),
        ),
        centerTitle: true,
        actions: [
          // Center(
          //   child: MaterialButton(
          //     //add profile photo button
          //     elevation: 0,
          //     height: 36.0,
          //     minWidth: 83.0,
          //     color: const Color(0xFFFF1BC6),

          //     shape: RoundedRectangleBorder(
          //       //side: BorderSide(color: Colors.white),
          //       borderRadius: BorderRadius.circular(50.0),
          //     ),
          //     textColor: Colors.white,
          //     onPressed: () async {
          //       SharedPreferences prefs = await SharedPreferences.getInstance();
          //       String token = prefs.getString('token');
          //     },
          //     child: Text(
          //       'Post',
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.normal,
          //           fontFamily: 'SFProDisplay'),
          //     ),
          //   ),
          // ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        maxLines: 6,
                        maxLength: 280,

                        style: TextStyle(color: Colors.white),
                        controller: textController,
                        keyboardType: TextInputType.text,
                        cursorColor: const Color(0xFFFF1BC6),
                        decoration: InputDecoration(
                          hintText: 'Type something….',
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
                SizedBox(width: 20.0, height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: new MaterialButton(
                        elevation: 0,
                        height: 35.0,
                        minWidth: 70.0,
                        color: const Color(0xFFFF1BC6),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0)),
                        textColor: Colors.white,
                        child: Text(
                          'Add media',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'VAG'),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String token = prefs.getString('token');
                          String email = prefs.getString('emailValue');
                          if (selectedValue == null) {
                            Fluttertoast.showToast(
                                msg: 'Select Category',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xFF6B174E),
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else if (textController.text == "") {
                            Fluttertoast.showToast(
                                msg: 'Enter Text',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xFF6B174E),
                                textColor: Colors.white,
                                fontSize: 14.0);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Upload(
                                  text: textController.text,
                                  category: selectedValue,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
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
