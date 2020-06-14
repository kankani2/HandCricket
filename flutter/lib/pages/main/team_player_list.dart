import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/user_stat.dart';

import '../../constants.dart';

class TeamPlayerListWidget extends StatefulWidget {
  final _TeamPlayerListWidgetState mState = new _TeamPlayerListWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _TeamPlayerListWidgetState extends State<TeamPlayerListWidget> {
  List<UserStat> _red = new List();
  List<UserStat> _blue = new List();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          _buildPlayerList(_red),
          _buildPlayerList(_blue),
        ],
      ),
    );
  }

  setPlayerStats(List<UserStat> red, List<UserStat> blue) {
    setState(() {
      _red = red;
      _blue = blue;
    });
  }

  Widget _buildPlayerList(List<UserStat> playerStats) {
    var playerContainers = new List<Widget>();
    playerStats.forEach((player) {
      playerContainers.add(Row(
        children: <Widget>[
          Expanded(
            child: _getText(player.user.name, 25),
          ),
          Column(
            children: <Widget>[
              _getText("R: ${player.runs}", 15),
              _getText("W: ${player.wickets}", 15),
            ],
          )
        ],
      ));
    });

    return Expanded(
      child: ListView(
        children: playerContainers,
      ),
    );
  }

  _getText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontFamily: primaryfont),
    );
  }
}
