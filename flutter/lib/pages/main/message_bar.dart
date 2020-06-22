import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MessageBarWidget extends StatefulWidget {
  final _MessageBarWidgetState mState = new _MessageBarWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _MessageBarWidgetState extends State<MessageBarWidget> {
  String _message = "";

  setMessage(String msg) {
    if (_message != msg) {
      setState(() {
        _message = msg;
      });
    }
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
            _message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: blackColor, fontSize: 25, fontFamily: primaryfont),
          ),
        ],
      ),
    );
  }
}
