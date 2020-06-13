import 'package:flutter/material.dart';
import 'package:handcricket/models/user.dart';

import '../constants.dart';

class PlayerTeamSelectWidget extends StatefulWidget {
  final _PlayerTeamSelectWidgetState _mState;

  PlayerTeamSelectWidget({Key key, @required player, @required group})
      : _mState = new _PlayerTeamSelectWidgetState(player, group),
        super(key: key);

  @override
  _PlayerTeamSelectWidgetState createState() => _mState;

  String getTeamName() {
    return teamMapping[_mState.group].name;
  }

  String getUID() {
    return _mState.player.uid;
  }
}

class _PlayerTeamSelectWidgetState extends State<PlayerTeamSelectWidget> {
  User player;
  int group;

  _PlayerTeamSelectWidgetState(this.player, this.group);

  List<Radio> getRadios() {
    var radios = new List<Radio>();
    teamMapping.forEach((index, team) {
      radios.add(Radio(
        value: index,
        groupValue: group,
        activeColor: team.color,
        onChanged: (selected) {
          setState(() {
            group = selected;
          });
        },
      ));
    });
    return radios;
  }

  @override
  Widget build(BuildContext context) {
    var children = new List<Widget>();
    children.add(Expanded(
      child: Text(
        player.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontFamily: primaryfont,
        ),
      ),
    ));
    children.addAll(getRadios());

    return Row(
      children: children,
    );
  }
}
