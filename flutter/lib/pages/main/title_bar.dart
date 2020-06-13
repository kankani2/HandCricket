import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TitleBarWidget extends StatefulWidget {
  final _TitleBarWidgetState mState = new _TitleBarWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _TitleBarWidgetState extends State<TitleBarWidget> {
  bool _redBatting = false;

  void setStatus(bool redBatting) {
    if (redBatting == _redBatting) {
      return;
    }

    setState(() {
      this._redBatting = redBatting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getChildren(_redBatting),
    );
  }

  String _getTitle(bool redBatting, int index) {
    // red is always index 0
    if ((redBatting && index == 0) || (!redBatting && index == 1)) {
      return "Batting";
    }

    return "Bowling";
  }

  List<Widget> _getChildren(bool redBatting) {
    var widgets = new List<Widget>(teamMapping.length);
    teamMapping.forEach((index, team) {
      widgets[index] = Expanded(
        child: Text(
          _getTitle(redBatting, index),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: team.color,
              fontSize: 30,
              fontFamily: primaryfont),
        ),
      );
    });
    return widgets;
  }
}
