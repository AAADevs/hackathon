import 'package:flutter/material.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 336.0,
      child: Column(
        children: <Widget>[Text('Add Profile Picture')],
      ),
    );
  }
}
