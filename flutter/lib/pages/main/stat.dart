import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class StatWidget extends StatefulWidget {
  final _StatWidgetState mState = new _StatWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _StatWidgetState extends State<StatWidget> {
  String _left = "";
  String _right = "";

  setStat(String left, String right) {
    if (_left != left) {
      setState(() {
        _left = left;
      });
    }

    if (_right != right) {
      setState(() {
        _right = right;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      color: blackColor,
      child: Row(
        children: <Widget>[
          _buildText(_left),
          _buildText(_right),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Text _buildText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style:
          TextStyle(color: yellowColor, fontSize: 25, fontFamily: primaryfont),
    );
  }
}
