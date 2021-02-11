import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:joyn_social_app/JoynApp/home.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeButtons extends StatefulWidget {
  final username;
  final tokens;
  final homeButtons;
  final currentWallpaper;
  HomeButtons({
    Key key,
    this.tokens,
    this.username,
    this.homeButtons,
    this.currentWallpaper,
  }) : super(key: key);

  @override
  _HomeButtons createState() => _HomeButtons();
}

class _HomeButtons extends State<HomeButtons> {
  bool buttonState = true;
  bool buyConfirmation = false;
  JoynTokenServices services = new JoynTokenServices();
  var userDetails;
  int length;
  var allItems;
  bool categoryList = true;
  bool loading = false;
  String passbaseverified = "Verified";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFFBCDD),
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.1,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(
            widget.homeButtons.length,
            (index) {
              if (widget.homeButtons[index]["uploader_username"] ==
                  widget.username) {
                return Container(
                  child: InkWell(
                    onTap: () {
                      purchasedItems(
                          widget.homeButtons[index]["imageURL"],
                          widget.homeButtons[index]["_id"],
                          widget.homeButtons[index]["type"],
                          widget.homeButtons[index]["name"],
                          widget.currentWallpaper);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                        height: MediaQuery.of(context).size.height * 5,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //color: Colors.blue[100],

                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      widget.homeButtons[index]["imageURL"],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                // Text(
                                //   "Your Item",
                                //   style: TextStyle(
                                //       fontSize: 18.0,
                                //       fontWeight: FontWeight.normal,
                                //       color: Colors.black,
                                //       fontFamily: 'VAG'),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (widget.homeButtons[index]["purchased"] == false) {
                return Container(
                  child: InkWell(
                    onTap: () {
                      _onButtonPressed(
                        widget.homeButtons[index]["uploader_username"],
                        widget.homeButtons[index]["imageURL"],
                        widget.homeButtons[index]["price"],
                        widget.homeButtons[index]["_id"],
                        widget.homeButtons[index]["type"],
                        widget.homeButtons[index]["name"],
                        widget.currentWallpaper,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                        height: MediaQuery.of(context).size.height * 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.network(
                            //   widget.homeButtons[index]["imageURL"],
                            //   fit: BoxFit.contain,

                            // ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //color: Colors.blue[100],

                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      widget.homeButtons[index]["imageURL"],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/tokenbutton.png",
                                  height: 24,
                                  width: 26,

                                  filterQuality: FilterQuality.high,
                                  //fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.homeButtons[index]["price"].toString(),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontFamily: 'VAG'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  child: InkWell(
                    onTap: () {
                      purchasedItems(
                          widget.homeButtons[index]["imageURL"],
                          widget.homeButtons[index]["_id"],
                          widget.homeButtons[index]["type"],
                          widget.homeButtons[index]["name"],
                          widget.currentWallpaper);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                        height: MediaQuery.of(context).size.height * 5,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 5.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //color: Colors.blue[100],

                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      widget.homeButtons[index]["imageURL"],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   "images/tokenbutton.png",
                                //   height: 24,
                                //   width: 26,

                                //   filterQuality: FilterQuality.high,
                                //   //fit: BoxFit.contain,
                                // ),

                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                )
                                // Text(
                                //   'Its Yours',
                                //   style: TextStyle(
                                //       fontSize: 18.0,
                                //       fontWeight: FontWeight.normal,
                                //       color: Colors.black,
                                //       fontFamily: 'VAG'),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       Container(
      //         color: const Color(0xFFFFBCDD),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               'Purchased',
      //               style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 18.0,
      //                   fontWeight: FontWeight.normal,
      //                   fontFamily: 'VAG'),
      //             ),
      //             IconButton(
      //               icon: categoryList
      //                   ? Icon(Icons.arrow_drop_up)
      //                   : Icon(Icons.arrow_drop_down),
      //               iconSize: 25,
      //               color: Colors.black,
      //               splashRadius: 20,
      //               splashColor: Colors.black,
      //               hoverColor: Colors.black,
      //               onPressed: () {
      //                 setState(() {
      //                   categoryList = !categoryList;
      //                 });
      //               },
      //             )
      //           ],
      //         ),
      //       ),
      //       Container(
      //         child: categoryList
      //             ? Container(
      //                 height: MediaQuery.of(context).size.height / 3,
      //                 color: const Color(0xFFFFBCDD),
      //                 child: GridView.count(
      //                   // Create a grid with 2 columns. If you change the scrollDirection to
      //                   // horizontal, this produces 2 rows.
      //                   crossAxisCount: 2,
      //                   childAspectRatio: 1 / 1.2,
      //                   // Generate 100 widgets that display their index in the List.
      //                   children: List.generate(
      //                     widget.homeButtons["purchased"].length,
      //                     (index) {
      //                       return Container(
      //                         child: InkWell(
      //                           onTap: () {
      //                             purchasedItems(
      //                               widget.homeButtons["purchased"][index]
      //                                   ["imageURL"],
      //                               widget.homeButtons["purchased"][index]
      //                                   ["_id"],
      //                               widget.homeButtons["purchased"][index]
      //                                   ["type"],
      //                               widget.homeButtons["purchased"][index]
      //                                   ["name"],
      //                               widget.wallpaper,
      //                             );
      //                           },
      //                           child: Padding(
      //                             padding: const EdgeInsets.only(
      //                                 left: 8.0, right: 8.0),
      //                             child: Container(
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 color: Colors.white,
      //                                 boxShadow: [
      //                                   BoxShadow(
      //                                     color: Colors.grey.withOpacity(0.5),
      //                                     spreadRadius: 5,
      //                                     blurRadius: 7,
      //                                     offset: Offset(0,
      //                                         3), // changes position of shadow
      //                                   ),
      //                                 ],
      //                               ),
      //                               margin: EdgeInsets.symmetric(
      //                                   vertical: 10, horizontal: 1),
      //                               height:
      //                                   MediaQuery.of(context).size.height * 5,
      //                               child: Column(
      //                                 children: [
      //                                   Padding(
      //                                     padding: const EdgeInsets.all(10.0),
      //                                     child: Container(
      //                                       height: MediaQuery.of(context)
      //                                               .size
      //                                               .height /
      //                                           5,
      //                                       decoration: BoxDecoration(
      //                                         borderRadius:
      //                                             BorderRadius.circular(10),
      //                                         //color: Colors.blue[100],

      //                                         image: DecorationImage(
      //                                           fit: BoxFit.contain,
      //                                           image: NetworkImage(
      //                                             widget.homeButtons[
      //                                                     "purchased"][index]
      //                                                 ["imageURL"],
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.center,
      //                                     children: [
      //                                       // Image.asset(
      //                                       //   "images/tokenbutton.png",
      //                                       //   height: 24,
      //                                       //   width: 26,

      //                                       //   filterQuality: FilterQuality.high,
      //                                       //   //fit: BoxFit.contain,
      //                                       // ),

      //                                       Icon(
      //                                         Icons.check_circle_outline,
      //                                         color: Colors.green,
      //                                         size: 30,
      //                                       )
      //                                       // Text(
      //                                       //   'Its Yours',
      //                                       //   style: TextStyle(
      //                                       //       fontSize: 18.0,
      //                                       //       fontWeight: FontWeight.normal,
      //                                       //       color: Colors.black,
      //                                       //       fontFamily: 'VAG'),
      //                                       // ),
      //                                     ],
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               )
      //             : null,
      //       ),
      //       Container(
      //         height: 2,
      //         width: MediaQuery.of(context).size.width,
      //         color: Colors.grey,
      //       ),
      //       Container(
      //         padding: EdgeInsets.all(15),
      //         color: const Color(0xFFFFBCDD),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               'Not Purchased',
      //               style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 18.0,
      //                   fontWeight: FontWeight.normal,
      //                   fontFamily: 'VAG'),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Container(
      //         height: MediaQuery.of(context).size.height,
      //         color: const Color(0xFFFFBCDD),
      //         child: GridView.count(
      //           // Create a grid with 2 columns. If you change the scrollDirection to
      //           // horizontal, this produces 2 rows.
      //           crossAxisCount: 2,
      //           childAspectRatio: 1 / 1.1,
      //           // Generate 100 widgets that display their index in the List.
      //           children: List.generate(
      //             widget.homeButtons["unpurchased"].length,
      //             (index) {
      //               // for (int i = 0;
      //               //     i < widget.wallpapersButtons["purchased"].length;i++){

      //               //     }
      //               // if (widget.wallpapersButtons["purchased"][index]
      //               //             ["imageURL"] allItems[index]["name"]) {}
      //               return Container(
      //                 child: InkWell(
      //                   onTap: () {
      //                     _onButtonPressed(
      //                       widget.homeButtons["unpurchased"][index]
      //                           ["imageURL"],
      //                       widget.homeButtons["unpurchased"][index]["price"],
      //                       widget.homeButtons["unpurchased"][index]["_id"],
      //                       widget.homeButtons["unpurchased"][index]["type"],
      //                       widget.homeButtons["unpurchased"][index]["name"],
      //                       widget.wallpaper,
      //                     );
      //                   },
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(10),
      //                         color: Colors.white,
      //                         boxShadow: [
      //                           BoxShadow(
      //                             color: Colors.grey.withOpacity(0.5),
      //                             spreadRadius: 5,
      //                             blurRadius: 7,
      //                             offset: Offset(
      //                                 0, 3), // changes position of shadow
      //                           ),
      //                         ],
      //                       ),
      //                       margin: EdgeInsets.symmetric(
      //                           vertical: 10, horizontal: 1),
      //                       height: MediaQuery.of(context).size.height * 5,
      //                       child: Column(
      //                         children: [
      //                           Padding(
      //                             padding: const EdgeInsets.all(10.0),
      //                             child: Container(
      //                               height: MediaQuery.of(context).size.height /
      //                                   5.5,
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 //color: Colors.blue[100],

      //                                 image: DecorationImage(
      //                                   fit: BoxFit.contain,
      //                                   image: NetworkImage(
      //                                     widget.homeButtons["unpurchased"]
      //                                         [index]["imageURL"],
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                           Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Image.asset(
      //                                 "images/tokenbutton.png",
      //                                 height: 24,
      //                                 width: 26,

      //                                 filterQuality: FilterQuality.high,
      //                                 //fit: BoxFit.contain,
      //                               ),
      //                               SizedBox(
      //                                 width: 5,
      //                               ),
      //                               Text(
      //                                 widget.homeButtons["unpurchased"][index]
      //                                         ["price"]
      //                                     .toString(),
      //                                 style: TextStyle(
      //                                     fontSize: 18.0,
      //                                     fontWeight: FontWeight.normal,
      //                                     color: Colors.black,
      //                                     fontFamily: 'VAG'),
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B174E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        'Home Buttons',
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: 'VAG'),
      ),
      actions: <Widget>[
        StatefulBuilder(
          builder: (context, state) {
            return Center(
              child: Text(
                widget.tokens.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: 'VAG'),
              ),
            );
          },
        ),
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

  void purchasedItems(String homeButton, String id, String type, String name,
      String wallpaper) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
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

            child: Container(
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
                    width: 224,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    height: 384,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Container(
                            height: 311,
                            width: 179,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                  homeButton,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6B174E),
                              fontFamily: 'VAG'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            width: 170,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9FF07A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Its Yours!',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontFamily: 'SF Pro Display'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Want to use it now?',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF6B174E),
                                fontFamily: 'SF Pro Display'),
                          ),
                          MaterialButton(
                            height: 35,
                            minWidth: 233,
                            color: Color(0xFF6B174E),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFF6B174E)),
                              borderRadius: BorderRadius.circular(9.0),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              String token = prefs.getString('token');
                              var updateSkin =
                                  await services.setDefault(token, id);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(
                                    passbaseStatus: passbaseverified,
                                    homebuttonUrl: homeButton,
                                    wallpaperUrl: wallpaper,
                                    passbaseverified: true,
                                  ),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'Apply to Feed',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: 'SF Pro Display'),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              'You can change your Feed Skin at any\n time in My Feed Controls',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6B174E),
                                  fontFamily: 'SF Pro Display'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              height: 650,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _onButtonPressed(String uploadername, String homebutton, int price,
      String id, String type, String name, String wallpaper) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, state) {
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

            child: Container(
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
                    width: 224,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Container(
                            height: 180,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  homebutton,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF6B174E),
                              fontFamily: 'VAG'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: buyConfirmation
                        ? Flexible(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9FF07A),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Its Yours!',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                            fontFamily: 'SF Pro Display'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Want to use it now?',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF6B174E),
                                        fontFamily: 'SF Pro Display'),
                                  ),
                                  MaterialButton(
                                    height: 35,
                                    minWidth: 233,
                                    color: Color(0xFF6B174E),
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Color(0xFF6B174E)),
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      String token = prefs.getString('token');
                                      var updateSkin =
                                          await services.setDefault(token, id);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(
                                            homebuttonUrl: homebutton,
                                            wallpaperUrl: wallpaper,
                                            passbaseverified: true,
                                            passbaseStatus: passbaseverified,
                                          ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: Text(
                                      'Apply to Feed',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'SF Pro Display'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      'You can change your Feed Skin at any\n time in My Feed Controls',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF6B174E),
                                          fontFamily: 'SF Pro Display'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/tokenbutton.png",
                                    height: 24,
                                    width: 26,

                                    filterQuality: FilterQuality.high,
                                    //fit: BoxFit.contain,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    price.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontFamily: 'VAG'),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                  ),
                                  Container(
                                    child: buttonState
                                        ? MaterialButton(
                                            height: 35,
                                            minWidth: 62,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.pink),
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            onPressed: () {
                                              updated(state);
                                              // state(() {
                                              //   buttonState = false;
                                              // });
                                            },
                                            child: Text(
                                              'Buy',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF6B174E),
                                                  fontFamily: 'VAG'),
                                            ),
                                          )
                                        : MaterialButton(
                                            height: 35,
                                            minWidth: 85,
                                            color: Color(0xFF6B174E),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Color(0xFF6B174E)),
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String token =
                                                  prefs.getString('token');

                                              if (price > widget.tokens) {
                                                Fluttertoast.showToast(
                                                    msg: 'Not enough tokens.',
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Color(0xFF6B174E),
                                                    textColor: Colors.white,
                                                    fontSize: 14.0);
                                              } else {
                                                // if (uploadername ==
                                                //     "JoynOrignalContent") {

                                                var buy = await services
                                                    .purchase(token, id);

                                                confirmBuy(state);
                                                print(buy);
                                              }
                                            },
                                            child: Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                  fontFamily: 'VAG'),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              // Center(
                              //   child: loading
                              //       ? CircularProgressIndicator()
                              //       : null,
                              // )
                            ],
                          ),
                  ),
                ],
              ),
              height: 650,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<Null> updated(StateSetter updateState) async {
    updateState(() {
      buttonState = false;
    });
  }

  Future<Null> confirmBuy(StateSetter updateState) async {
    updateState(() {
      buyConfirmation = true;
    });
  }
}
