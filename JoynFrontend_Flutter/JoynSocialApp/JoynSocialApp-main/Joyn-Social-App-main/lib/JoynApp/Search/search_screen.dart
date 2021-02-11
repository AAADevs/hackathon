import 'package:flutter/material.dart';
import 'package:joyn_social_app/AuthServices/JoynTokenServices.dart';
import 'package:joyn_social_app/AuthServices/authservices.dart';
import 'package:joyn_social_app/JoynApp/profile.dart';
import 'package:joyn_social_app/JoynApp/userProfilePage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../userProfilePage.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = "";
  var accountinfo;
  var userdetails;
  AuthServices authservice = new AuthServices();
  JoynTokenServices services = new JoynTokenServices();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff5D0B49), Color(0xff441265)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: _mediaQuery.height * 0.1),
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Colors.transparent.withOpacity(0.3),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)),
                filled: true,
                hintText: "Looking for someone?",
                hintStyle: TextStyle(
                    fontFamily: "VAG", color: Colors.grey, letterSpacing: 2),
              ),
              style: TextStyle(
                  color: Colors.white, fontFamily: "VAG", letterSpacing: 2),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
                if (_searchText.length > 2) _getSearchData();
              },
            ),
            Flexible(child: SizedBox(height: _mediaQuery.height * 0.08)),
            Row(
              children: [
                Text("Matched profiles",
                    style: TextStyle(
                        fontFamily: "VAG", fontSize: 20, color: Colors.white)),
                Spacer(),
                Lottie.asset(
                  "assets/animations/poeple-animation.json",
                  height: _mediaQuery.height * 0.1,
                  width: _mediaQuery.width * 0.1,
                ),
              ],
            ),
            FutureBuilder(
              future: _getSearchData(),
              builder: (context, snapshots) {
                List users = [];
                if (snapshots.connectionState == ConnectionState.waiting)
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: _mediaQuery.height * 0.13),
                        CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      ],
                    ),
                  );

                if (snapshots.hasError) return Center(child: Icon(Icons.error));

                if (snapshots.hasData) if (!users.contains(snapshots.data))
                  users.add(snapshots.data["data"]);
                print(users);

                if (users.isEmpty)
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: _mediaQuery.height * 0.2),
                        Text(
                          _searchText.isEmpty
                              ? "Search for an user"
                              : "No users found",
                          style: TextStyle(
                              fontFamily: "VAG",
                              color: Colors.grey,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  );

                return Flexible(
                  flex: 5,
                  child: ListView.separated(
                    itemCount: users[0].length,
                    separatorBuilder: (context, index) => Divider(
                        height: 20, color: Colors.transparent, thickness: 0),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: users[0][index]["profile_picture"] == "NA"
                            ? CircleAvatar(
                                backgroundColor: Colors.black45,
                                child: Icon(Icons.person, color: Colors.black),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    users[0][index]["profile_picture"]),
                              ),
                        title: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            users[0][index]["username"],
                            style: TextStyle(
                              fontFamily: "VAG",
                              letterSpacing: 2,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        tileColor: Colors.white.withOpacity(0.7),
                        enabled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        selectedTileColor: Colors.white.withOpacity(0.6),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          String accountID = prefs.getString('accountID');
                          // checkFollower()
                          await getUserDetails(users[0][index]["email"]);
                          if (userdetails["data"][0]["_id"] == accountID) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  userfromSearchResult: true,
                                  profilepic: accountinfo["data"]["user"]
                                      ["profile_picture"],
                                  username: accountinfo["data"]["user"]
                                      ["username"],
                                ),
                              ),
                            );
                          } else
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile(
                                    userfromSearchResult: true,
                                    profilepic: userdetails["data"][0]
                                        ["profile_picture"],
                                    username: userdetails["data"][0]
                                        ["username"],
                                    followlist: accountinfo["data"]["user"]
                                        ["following"],
                                    userid: userdetails["data"][0]["_id"]),
                              ),
                            );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _getSearchData() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String username = prefs.getString('userName');

    accountinfo = await services.accountInfo(token, username);
    final result = await AuthServices().getSearchData(token, _searchText);
    return result;
  }

  Future getUserDetails(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String username = prefs.getString('userName');
    String token = prefs.getString('token');

    userdetails = await authservice.userDetails(token, email);

    return userdetails;
  }
}
