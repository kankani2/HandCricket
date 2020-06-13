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
    setHands(0, 0);
  }

  setHands(int redHand, int blueHand) {
    if (_redHand != redHand) {
      setState(() {
        _redHand = redHand;
      });
    }
    if (_blueHand != blueHand) {
      setState(() {
        _blueHand = blueHand;
      });
    }
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
