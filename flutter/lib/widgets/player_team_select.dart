import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';

import '../constants.dart';

class PlayerTeamSelectWidget extends StatefulWidget {
  final User player;
  final _PlayerTeamSelectWidgetState _mState;

  PlayerTeamSelectWidget({Key key, @required this.player, @required group})
      : _mState = new _PlayerTeamSelectWidgetState(player, group),
        super(key: key);

  @override
  _PlayerTeamSelectWidgetState createState() => _mState;

  String getTeamName() {
    if (_mState.group == 0) return "redTeam";
    return "blueTeam";
  }

  String getUID() {
    return _mState.player.uid;
  }
}

class _PlayerTeamSelectWidgetState extends State<PlayerTeamSelectWidget> {
  User player;
  int group;

  _PlayerTeamSelectWidgetState(this.player, this.group);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            player.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontFamily: primaryfont,
            ),
          ),
        ),
        Radio(
          value: 0,
          groupValue: group,
          activeColor: Colors.red,
          onChanged: (selected) {
            setState(() {
              group = selected;
            });
          },
        ),
        Radio(
          value: 1,
          focusColor: Colors.blue[900],
          groupValue: group,
          onChanged: (selected) {
            setState(() {
              group = selected;
            });
          },
        ),
      ],
    );
  }
}
