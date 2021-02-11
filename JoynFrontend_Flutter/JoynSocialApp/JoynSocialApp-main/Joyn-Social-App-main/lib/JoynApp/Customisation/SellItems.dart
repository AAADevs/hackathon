import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellPage extends StatefulWidget {
  SellPage({
    Key key,
  }) : super(key: key);

  @override
  _SellPage createState() => _SellPage();
}

class _SellPage extends State<SellPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  List<String> _locations = ['wallpaper', 'homebutton', 'icon'];
  String _selectedLocation;
  int price;
  JoynTokenServices tokenServices = new JoynTokenServices();
  //final bottom = MediaQuery.of(context).viewInsets.bottom;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.clear();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF1BC6),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          File file = await ImagePicker.pickImage(
            source: ImageSource.gallery,
          );
          print(file.path);
          if (file != null) {
            _onButtonPressed(file, context);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return TrimmerViewVibe(_trimmer);
            //     },
            //   ),
            // );
          }
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B174E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        'Sell Content',
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: 'VAG'),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "images/tokenbutton.png",
            height: 30,
            width: 30,

            filterQuality: FilterQuality.high,
            //fit: BoxFit.contain,
          ),
        ),
      ],
      centerTitle: true,
    );
  }

  void _onButtonPressed(File file, context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Scaffold(
          // resizeToAvoidBottomInset: true,
          // resizeToAvoidBottomPadding: true,
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                //height: 650,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                //color: Colors.transparent,

                child: SingleChildScrollView(
                  //reverse: true,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 9,
                        ),
                        Container(
                          height: 5,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          //margin: EdgeInsets.symmetric(vertical: 10),
                          height: 384,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: _selectedLocation == "wallpaper"
                                  ? 9 / 16
                                  : _selectedLocation == "homebutton"
                                      ? 1
                                      : _selectedLocation == "icon"
                                          ? 1
                                          : 1,
                              child: Container(
                                // height: 311,
                                // width: 179,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,

                                    image: FileImage(file),
                                    // ResizeImage(
                                    //   FileImage(file),
                                    //   height: 50,
                                    //   width: 70,
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),
                        // new DropdownButton<String>(
                        //   items: <String>['wallpaper', 'homebutton', 'icon']
                        //       .map((String value) {
                        //     return new DropdownMenuItem<String>(
                        //       value: value,
                        //       child: new Text(value),

                        //     );
                        //   }).toList(),
                        //   onChanged: (_) {},

                        // )
                        Column(
                          children: [
                            Text(
                              'Type',
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.pink,
                                  fontFamily: 'VAG'),
                            ),
                            DropdownButton(
                              hint: Text(
                                  'Please choose an option.'), // Not necessary for Option 1
                              value: _selectedLocation,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedLocation = newValue;
                                });
                              },
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Container(
                          //email or username input field
                          padding: EdgeInsets.only(
                              left: 20.0, top: 17.0, right: 19.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontFamily: 'VAG',
                            ),
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Name *',
                              hintStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'VAG',
                                  color: Colors.black26),
                              fillColor: Colors.white24,
                              filled: true,
                              focusColor: const Color(0x66FFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        Container(
                          //email or username input field
                          padding: EdgeInsets.only(
                              left: 20.0, top: 17.0, right: 19.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontFamily: 'VAG',
                            ),
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            // onChanged: (value) {
                            //   setState(() {
                            //     price = value as int;
                            //     print(price);
                            //   });
                            // },
                            decoration: InputDecoration(
                              hintText: 'Price *',
                              hintStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'VAG',
                                  color: Colors.black26),
                              fillColor: Colors.white24,
                              filled: true,
                              focusColor: const Color(0x66FFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: 150,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String token = prefs.getString('token');

                              if (_selectedLocation != null &&
                                  nameController.text != "" &&
                                  priceController.text != "") {
                                var data = await tokenServices.uploadItemtoShop(
                                    token,
                                    _selectedLocation,
                                    nameController.text,
                                    priceController.text,
                                    file.path);
                                print(data);

                                if (data == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Duplicate Item',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xFF6B174E),
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                } else if (data["result"] == true) {
                                  Navigator.pop(context);
                                }
                              } else if (_selectedLocation == null ||
                                  nameController.text == "" ||
                                  priceController.text == "") {
                                Fluttertoast.showToast(
                                    msg: 'Enter all the fields.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Color(0xFF6B174E),
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text("Sell".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        // return StatefulBuilder(
        //   builder: (context, state) {
        //     return Container(
        //       decoration: BoxDecoration(
        //         color: Colors.transparent,
        //         borderRadius: BorderRadius.only(
        //           topLeft: const Radius.circular(10),
        //           topRight: const Radius.circular(10),
        //         ),
        //       ),
        //       child: Container(
        //         child: Column(
        //           children: [
        //             Container(
        //               child: Image.file(file),
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // );
      },
    );
  }
}
