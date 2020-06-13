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
    setState(() {
      _left = left;
      _right = right;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildText(_left),
        _buildText(_right),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Text _buildText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style:
          TextStyle(color: Colors.white, fontSize: 25, fontFamily: primaryfont),
    );
  }
}
