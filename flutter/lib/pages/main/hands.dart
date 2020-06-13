import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class HandsWidget extends StatefulWidget {
  final _HandsWidgetState mState = new _HandsWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _HandsWidgetState extends State<HandsWidget> {
  int _redHand = 0;
  int _blueHand = 0;

  reset() {
    setState(() {
      _redHand = 0;
      _blueHand = 0;
    });
  }

  setHands(int redHand, int blueHand) {
    setState(() {
      _redHand = redHand;
      _blueHand = blueHand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Image.asset(handMap["red"][_redHand]),
        ),
        Expanded(
          child: Image.asset(handMap["blue"][_blueHand]),
        )
      ],
    );
  }
}
