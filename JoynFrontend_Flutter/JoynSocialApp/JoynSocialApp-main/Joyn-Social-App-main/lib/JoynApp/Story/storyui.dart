import 'package:flutter/material.dart';

class StoryUI extends StatefulWidget{
  final  dp;
  final  name;

  StoryUI({
    Key key,
    this.dp,
    this.name,
}): super(key :key);
  @override
  _StoryUIState createState() => _StoryUIState();
}

class _StoryUIState extends State<StoryUI>{

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Flexible(child: SizedBox(height: 7)),
          CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xffcc306C),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(widget.dp),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.name,
            style: TextStyle(
                fontSize: 13,
                color: Colors.white
            ),
          ),
        ],
    );
  }
}