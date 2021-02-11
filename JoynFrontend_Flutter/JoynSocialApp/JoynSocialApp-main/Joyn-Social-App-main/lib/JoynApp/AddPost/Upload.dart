import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../main_screen.dart';

class Upload extends StatefulWidget {
  final text;
  final category;

  Upload({
    Key key,
    this.category,
    this.text,
  }) : super(key: key);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // variable section
  List<Widget> fileListThumb;
  List<dynamic> fileList = new List<dynamic>();
  List<dynamic> files;
  List<PlatformFile> paths;
  List<dynamic> allPaths = [];
  var filePath;
  var thumbnail;
  var thumb;
  List<String> picExt = ['.jpg', '.jpeg', '.bmp', '.mp4', '.png'];
  List<String> videoExt = ['.mp4', '.bmp'];
  bool _progressVisibility = false;
  AuthServices service = new AuthServices();
  var getUserDetails;
  String passbaseVerified = "Verified";

  /*Future genThumbnailFile(path) async{
    Uint8List bytes;
     thumbnail = await VideoThumbnail.thumbnailFile(
        video: path,
        //thumbnailPath: (await getTemporaryDirectory()).path,
        // thumbnailPath: _tempDir,
        imageFormat: ImageFormat.JPEG,
        //maxHeightOrWidth: 0,
        quality: 75);
    setState(() {
      final file = File(thumbnail);
      filePath = file.path;
      bytes = file.readAsBytesSync();
      print(filePath);
      print(bytes);

      print(thumbnail);
    });
  }

    } */

  @override
  void initState() {
    super.initState();
    this.addAllUrls();
  }

  addAllUrls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('emailValue');
    String token = prefs.getString('token');

    getUserDetails = await service.userDetails(token, email);
  }

  genThumbnailFile(path) async {
    //var appDocDir = await getApplicationDocumentsDirectory();
    //final folderPath = appDocDir.path;
    thumb = await Thumbnails.getThumbnail(
        //thumbnailFolder: folderPath,
        videoFile: path,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 75);
    print(thumb);
    return thumb;
  }

  Future pickFiles() async {
    List<Widget> thumbs = new List<Widget>();
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

    files = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'bmp',
        'pdf',
        'doc',
        'docx',
        'mp4',
        'png'
      ],
    ))
        ?.files;
    print(files);
    addAllPaths();
    paths = files;
    if (files != null && files.length <= 4) {
      files.forEach((element) {
        print(element);
        print(element.path);

        int j = element.path.lastIndexOf('.');
        var fileresultPath;

        print(videoExt.contains(element.path.substring(j)));

        if (videoExt.contains(element.path.substring(j))) {
          genThumbnailFile(element.path);
          print(thumb);

          for (int i = 0; i < 10; i++) {
            print(thumb);
          }
          print(thumb);

          if (thumb != null) {
            thumbs.add(Padding(
              padding: EdgeInsets.all(1),
              child: Image.file(new File(thumb)),
            ));
            //print("reacherd");
          } else {
            Center(child: CircularProgressIndicator());
            //print("NOT REACHED");
          }

          /*filePath != null ?
            thumbs.add(Padding(
              padding: EdgeInsets.all(1),
              child:Image.file(new File(filePath)),
            )
            )
                :  Center(
                child: CircularProgressIndicator()); */

          //child: CircleAvatar(
          //child: Video.File(new File (element.path)),
          //backgroundColor: Color(0xFFFD6CCA),

          //),

          //child: CircleAvatar(
          //child: Video.File(new File (element.path)),
          //backgroundColor: Color(0xFFFD6CCA),

          //),

        } else {
          thumbs.add(Padding(
            padding: EdgeInsets.all(1),
            //child: CircleAvatar(
            child: Image.file(new File(element.path)),
            //backgroundColor: Color(0xFFFD6CCA),

            //),
          ));
        }

        /*if(picExt.contains((element.path))){
            thumbs.add(Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.1, top: MediaQuery.of(context).size.height*0.1),
                //child: CircleAvatar(
                    child:new Image.file((element)),
                    //backgroundColor: Color(0xFFFD6CCA),

                //),

            )
            );
          }
          else
            thumbs.add( Container(
                child : Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      Icon(Icons.insert_drive_file, color: Colors.white,),
                      Text((element.path))
                    ]
                )
            )); */
        fileList.add(element);
      });
      setState(() {
        fileListThumb = thumbs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fileListThumb == null)
      fileListThumb = [
        InkWell(
          onTap: pickFiles,
          child: Container(child: Icon(Icons.add, color: Colors.white)),
        )
      ];
    //final Map params = final Map params = new Map();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Visibility(
              visible: _progressVisibility,
              child: LinearProgressIndicator(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Add Files",
              style: TextStyle(fontFamily: 'VAG'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF09091F),
      ),
      backgroundColor: const Color(0xFF09091F),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: GridView.count(
            crossAxisCount: 4,
            children: fileListThumb,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = prefs.getString('token');

          print(allPaths); //printing all the file paths
          setState(() {
            _progressVisibility = true;
          });
          var feeddata = await service.postNewFeedJot(
              allPaths, token, widget.text, widget.category);

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
        }, //(upload function) modify latter (2)
        backgroundColor: const Color(0xFFFF1BC6),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.0)),
        child: Text(
          'Post',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'VAG'),
        ),
      ),
      /*Container(
        /*constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background3x.png"),
                fit: BoxFit.cover)), */
        child: SingleChildScrollView(
          child: Theme(
            data: new ThemeData(
              primaryColor: Color(0xFFFD6CCA),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                Text(
                  'Add File',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'SFProDisplay'),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: fileListThumb,
                  ),
                ), // modify later (1)
                //SizedBox(height: MediaQuery.of(context).size.height*0.1),
                FloatingActionButton(
                  onPressed: null, //(upload function) modify latter (2)
                  backgroundColor: const Color(0xFFFF1BC6),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'SFProDisplay'),
                  ),
                ),
              ],
            ),
          )
        )

      ), */
    );
  }

  addAllPaths() {
    int length = files.length;
    for (int i = 0; i < length; i++) {
      allPaths.add(files[i].path);
    }
  }
}
