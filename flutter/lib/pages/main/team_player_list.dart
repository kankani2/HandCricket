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
          VerticalDivider(
            thickness: 4,
            color: blackColor,
            indent: 15,
            endIndent: 15,
          ),
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
      playerContainers.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getText(player.user.name, 25),
            SizedBox(
              width: 15,
            ),
            Column(
              children: <Widget>[
                _getText("R: ${player.runs}", 15),
                _getText("W: ${player.wickets}", 15),
              ],
            )
          ],
        ),
      );
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
          color: blackColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          fontFamily: primaryfont),
    );
  }
}
