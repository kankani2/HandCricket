import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_stat.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/models/user_stat.dart';
import 'package:handcricket/pages/main/dice.dart';
import 'package:handcricket/pages/main/hands.dart';
import 'package:handcricket/pages/main/stat.dart';
import 'package:handcricket/pages/main/team_player_list.dart';
import 'package:handcricket/pages/main/title_bar.dart';
import 'package:handcricket/utils/cache.dart';

import '../../constants.dart';

class MainGamePage extends StatefulWidget {
  final Cache<User> userCache;

  const MainGamePage({Key key, @required this.userCache}) : super(key: key);

  @override
  _MainGamePageState createState() => _MainGamePageState(userCache);
}

class _MainGamePageState extends State<MainGamePage> {
  TitleBarWidget titleBar = TitleBarWidget();
  HandsWidget hands = HandsWidget();
  StatWidget topStats = StatWidget();
  StatWidget bottomStats = StatWidget();
  TeamPlayerListWidget teamPlayersList;

  Cache<User> _userCache;

  _MainGamePageState(this._userCache)
      : teamPlayersList = TeamPlayerListWidget(userCache: _userCache);

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
              teamPlayersList,
              DiceWidget(),
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

    teamPlayersList.mState.setPlayerStats(<UserStat>[
      UserStat(User("", "Ayush", 2), 30, 3),
      UserStat(User("", "Pooja", 2), 40, 0)
    ], <UserStat>[
      UserStat(User("", "lol", 2), 3, 0),
      UserStat(User("", "test", 2), 0, 0)
    ]);
  }
}
