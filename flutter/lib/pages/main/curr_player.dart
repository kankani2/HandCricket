import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/user.dart';

import '../../constants.dart';

class CurrPlayerWidget extends StatefulWidget {
  final _CurrPlayerWidgetState mState = new _CurrPlayerWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _CurrPlayerWidgetState extends State<CurrPlayerWidget> {
  User _redCurrUser = new User("", "Red Player", 0);
  User _blueCurrUser = new User("", "Blue Player", 0);

  void setStatus(User redCurrUser, User blueCurrUser) {
    setState(() {
      this._redCurrUser = redCurrUser;
      this._blueCurrUser = blueCurrUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getChildren(_redCurrUser, _blueCurrUser),
    );
  }

  Expanded _getPlayerAndIcon(User currUser, Color color) {
    return Expanded(
      child: Row(
        children: <Widget>[
          ImageIcon(
            AssetImage(iconMap[currUser.icon]),
            size: 45,
            color: color,
          ),
          Text(
            currUser.name,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontFamily: primaryfont,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getChildren(User redCurrUser, User blueCurrUser) {
    var widgets = new List<Widget>();
    widgets.add(_getPlayerAndIcon(redCurrUser, Colors.red));
    widgets.add(_getPlayerAndIcon(blueCurrUser, Colors.blue[900]));
    return widgets;
  }
}
