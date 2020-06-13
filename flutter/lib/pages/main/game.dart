import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_stat.dart';
import 'package:handcricket/pages/main/hands.dart';
import 'package:handcricket/pages/main/stat.dart';
import 'package:handcricket/pages/main/title_bar.dart';

import '../../constants.dart';

class MainGamePage extends StatefulWidget {
  @override
  _MainGamePageState createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  TitleBarWidget titleBar = TitleBarWidget();
  StatWidget topStats = StatWidget();
  StatWidget bottomStats = StatWidget();
  HandsWidget hands = HandsWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: <Widget>[
              titleBar,
              hands,
              topStats,
              bottomStats,
              FlatButton(
                color: Colors.blue[900],
                onPressed: _onPress,
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPress() {
    titleBar.mState.setStatus(true);

    var game = GameStat(2, 2, 1, 30);
    topStats.mState.setStat(game.score(), game.overs());
    bottomStats.mState.setStat(game.target(), game.toWin());

    Random random = new Random();
    hands.mState.setHands(random.nextInt(7), random.nextInt(7));
  }
}
