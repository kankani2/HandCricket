import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MessageBarWidget extends StatefulWidget {
  final _MessageBarWidgetState mState = new _MessageBarWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _MessageBarWidgetState extends State<MessageBarWidget> {
  String message = "";

  setMessage(String msg) {
    setState(() {
      message = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: blackColor, fontSize: 25, fontFamily: primaryfont),
          ),
        ],
      ),
    );
  }
}
