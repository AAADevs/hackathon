import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/Search/search_screen.dart';
import 'package:joyn_social_app/JoynApp/home.dart';
import 'package:joyn_social_app/JoynApp/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final String wallpaperUrl;
  final String homebuttonUrl;
  final bool passbaseverified;
  final String passbaseStatus;

  MainScreen({
    Key key,
    this.wallpaperUrl,
    this.homebuttonUrl,
    this.passbaseverified,
    this.passbaseStatus,
  }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 2;
  String username;
  String profilepic;
  AuthServices service = new AuthServices();
  var getUserDetails;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
    this.getUserdetails();
  }

  Future getUserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.getString('userName');
    String email = prefs.getString('emailValue');
    String token = prefs.getString('token');
    getUserDetails = await service.userDetails(token, email);
    print(getUserDetails["data"][0]);
    return getUserDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Center(child: Text("Demo page 1")),
          //Center(child: Text("Demo page 2")),
          SearchScreen(),
          new Home(
            wallpaperUrl: widget.wallpaperUrl,
            homeButtonUrl: widget.homebuttonUrl,
            passbaseVerified: widget.passbaseverified,
            passbaseStatus: widget.passbaseStatus,
          ),
          Center(child: Text("Demo page 4")),
          //Center(child: Text("Demo page 5")),
          FutureBuilder(
            future: getUserdetails(),
            builder: (context, projectSnap) {
              if (!projectSnap.hasData) {
                print('project snapshot data is: ${projectSnap.data}');

                return Center(child: CircularProgressIndicator());
              } else {
                return Profile(
                  username: getUserDetails["data"][0]["username"],
                  profilepic: getUserDetails["data"][0]["profile_picture"],
                  userfromSearchResult: false,
                );
              }
            },
          ),
          //  Profile(
          //   username: getUserDetails["data"][0]["username"],
          //   profilepic: getUserDetails["data"][0]["profile_picture"],
          // ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: const Color(0xFF09091F),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: new Image.asset(
                "images/shuttle.png",
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(
                "images/search.png",
                height: 30,
                width: 30,
                //fit: BoxFit.contain,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: widget.homebuttonUrl == "" || widget.homebuttonUrl == null
                  ? Image.asset(
                      "images/joyn_donut.png",
                      height: 35,
                      width: 35,
                      //fit: BoxFit.contain,
                    )
                  : Image.network(
                      widget.homebuttonUrl,
                      fit: BoxFit.contain,
                      height: 41,
                    ),
              // Container(
              //     child: Image.network(
              //       widget.homebuttonUrl,
              //       fit: BoxFit.cover,
              //     ),
              //     height: 41,
              //     width: 42,
              //   ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(
                "images/heart.png",
                height: 30,
                width: 30,
                //fit: BoxFit.contain,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: new Image.asset(
                "images/profile.png",
                height: 30,
                width: 30,
                //fit: BoxFit.contain,
              ),
              label: "",
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  Future<void> navigationTapped(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userName');
      profilepic = prefs.getString('profilepic');
    });

    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> onPageChanged(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      this._page = page;
      username = prefs.getString('userName');
      profilepic = prefs.getString('profilepic');
    });
  }
}
