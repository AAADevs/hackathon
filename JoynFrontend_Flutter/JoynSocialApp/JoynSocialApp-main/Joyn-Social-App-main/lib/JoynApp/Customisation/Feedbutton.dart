import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/home.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feedbutton extends StatefulWidget {
  final tokens;
  final wallpapersButtons;
  Feedbutton({
    Key key,
    this.tokens,
    this.wallpapersButtons,
  }) : super(key: key);

  @override
  _Feedbutton createState() => _Feedbutton();
}

class _Feedbutton extends State<Feedbutton> {
  bool buttonState = true;
  bool buyConfirmation = false;
  JoynTokenServices services = new JoynTokenServices();
  var userDetails;
  bool categoryList = true;

  @override
  void initState() {
    super.initState();
    //this.userdetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFFFBCDD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Purchased',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'VAG'),
                  ),
                  IconButton(
                    icon: categoryList
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down),
                    iconSize: 25,
                    color: Colors.black,
                    splashRadius: 20,
                    splashColor: Colors.black,
                    hoverColor: Colors.black,
                    onPressed: () {
                      setState(() {
                        categoryList = !categoryList;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              child: categoryList
                  ? Container(
                      color: const Color(0xFFFFBCDD),
                      child: GridView.count(
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.1,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(
                          widget.wallpapersButtons["purchased"].length,
                          (index) {
                            return Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(10),
                              //       topRight: Radius.circular(10),
                              //       bottomLeft: Radius.circular(10),
                              //       bottomRight: Radius.circular(10)),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.grey.withOpacity(0.5),
                              //       spreadRadius: 5,
                              //       blurRadius: 7,
                              //       offset: Offset(0, 3), // changes position of shadow
                              //     ),
                              //   ],
                              // ),
                              child: InkWell(
                                onTap: () {
                                  purchasedItem(
                                    widget.wallpapersButtons["purchased"][index]
                                        ["imageURL"],
                                    widget.wallpapersButtons["purchased"][index]
                                        ["_id"],
                                    widget.wallpapersButtons["purchased"][index]
                                        ["type"],
                                    widget.wallpapersButtons["purchased"][index]
                                        ["name"],
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 1),
                                    height:
                                        MediaQuery.of(context).size.height * 5,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5.7,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              //color: Colors.blue[100],

                                              image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: NetworkImage(
                                                  widget.wallpapersButtons[
                                                          "purchased"][index]
                                                      ["imageURL"],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              widget.wallpapersButtons[
                                                      "purchased"][index]
                                                      ["price"]
                                                  .toString(),
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
                          },
                        ),
                      ),
                    )
                  : null,
            ),
            Container(
              height: 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(15),
              color: const Color(0xFFFFBCDD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not Purchased',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'VAG'),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFFFBCDD),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.1,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(
                  widget.wallpapersButtons["purchased"].length,
                  (index) {
                    return Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(10),
                      //       topRight: Radius.circular(10),
                      //       bottomLeft: Radius.circular(10),
                      //       bottomRight: Radius.circular(10)),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 5,
                      //       blurRadius: 7,
                      //       offset: Offset(0, 3), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                      child: InkWell(
                        onTap: () {
                          _onButtonPressed(
                            widget.wallpapersButtons["unpurchased"][index]
                                ["imageURL"],
                            widget.wallpapersButtons["unpurchased"][index]
                                ["_id"],
                            widget.wallpapersButtons["unpurchased"][index]
                                ["type"],
                            widget.wallpapersButtons["unpurchased"][index]
                                ["name"],
                            widget.wallpapersButtons["unpurchased"][index]
                                ["price"],
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
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 1),
                            height: MediaQuery.of(context).size.height * 5,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        5.7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //color: Colors.blue[100],

                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                          widget.wallpapersButtons[
                                              "unpurchased"][index]["imageURL"],
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
                                      widget.wallpapersButtons["unpurchased"]
                                              [index]["price"]
                                          .toString(),
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<Null> userdetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String username = prefs.getString('userName');
  //   String token = prefs.getString('token');

  //   userDetails = await services.accountInfo(token, username);
  //   print(userDetails);
  // }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B174E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        'Feed Skins',
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
                widget.tokens,
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

  void purchasedItem(String imageUrl, String id, String type, String name) {
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
                    height: 46,
                    width: 268,
                    child: Center(
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'VAG'),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFFD6CCA),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    width: 268,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    height: 251,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Container(
                            height: 136,
                            width: 132,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue[100],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Homebutton',
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
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(
                                      //wallpaper: true,
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

  void _onButtonPressed(
      String imageUrl, int price, String id, String type, String name) {
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
                    height: 46,
                    width: 268,
                    child: Center(
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontFamily: 'VAG'),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFFD6CCA),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    width: 268,
                    //margin: EdgeInsets.symmetric(vertical: 10),
                    height: 251,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Container(
                            height: 136,
                            width: 132,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue[100],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Homebutton',
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
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(
                                              //wallpaper: true,
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
                        : Row(
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
                                width: MediaQuery.of(context).size.width / 4,
                              ),
                              Container(
                                child: buttonState
                                    ? MaterialButton(
                                        height: 35,
                                        minWidth: 62,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.pink),
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
                                          String username =
                                              prefs.getString('userName');
                                          String token =
                                              prefs.getString('token');
                                          confirmBuy(state);

                                          var response =
                                              await services.deductTokens(
                                                  "10", token, username);
                                          print(response);
                                          // state(() {
                                          //   buttonState = false;
                                          // });
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
