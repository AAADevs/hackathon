import 'package:flutter/material.dart';
import 'package:joyn_social_app/JoynApp/main_screen.dart';

class IconPacks extends StatefulWidget {
  IconPacks({
    Key key,
  }) : super(key: key);

  @override
  _IconPacks createState() => _IconPacks();
}

class _IconPacks extends State<IconPacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        color: const Color(0xFFFFBCDD),
        child: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.1,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return InkWell(
              onTap: () {
                _onButtonPressed();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                  height: MediaQuery.of(context).size.height * 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 5.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF4F4F4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                          Text(
                            '100',
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
            );
          }),
        ),
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
        'Icon Packs',
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

  void _onButtonPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 650,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
          //color: Colors.transparent,

          child: Container(
            child: _buildBottomNavigationMenu(),
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
      },
    );
  }

  Column _buildBottomNavigationMenu() {
    return Column(
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
          width: 296,
          //margin: EdgeInsets.symmetric(vertical: 10),
          height: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Container(
                  height: 230,
                  width: 200,
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
                'Icon Pack',
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
            Text(
              '100',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: 'VAG'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            MaterialButton(
              height: 35,
              minWidth: 62,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.pink),
                borderRadius: BorderRadius.circular(9.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Buy',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B174E),
                    fontFamily: 'VAG'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
