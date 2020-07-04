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
    if (msg == null) {
      msg = "";
    }
    if (_message != msg) {
      setState(() {
        _message = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: blackColor, fontSize: 25, fontFamily: primaryfont),
      ),
    );
  }
}
