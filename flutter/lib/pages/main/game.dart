import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/game_stat.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/models/user_stat.dart';
import 'package:handcricket/pages/game_home.dart';
import 'package:handcricket/pages/main/curr_player.dart';
import 'package:handcricket/pages/main/dice.dart';
import 'package:handcricket/pages/main/hands.dart';
import 'package:handcricket/pages/main/stat.dart';
import 'package:handcricket/pages/main/team_player_list.dart';
import 'package:handcricket/pages/main/title_bar.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/utils/cache.dart';

import '../../constants.dart';

enum CurrUserStatus { BAT, BOWL, VIEWER }

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
  CurrPlayerWidget currPlayer = CurrPlayerWidget();
  TeamPlayerListWidget teamPlayersList = TeamPlayerListWidget();
  DiceWidget dice = DiceWidget();

  Cache<User> _userCache;
  User _self;
  CurrUserStatus currUserStatus = CurrUserStatus.VIEWER;
  GameInfo _game;
  DatabaseReference _gameRef;
  DataSnapshot snapshot;

  _MainGamePageState(this._userCache);

  @override
  void initState() {
    super.initState();
    _mainRoutine();
  }

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
              currPlayer,
              topStats,
              bottomStats,
              teamPlayersList,
              dice,
            ],
          ),
        ),
      ),
    );
  }

  _mainRoutine() async {
    _self = await User.getUserFromDisk();
    _game = await GameInfo.getGameInfoFromDisk();
    dice.mState.registerCallback(_onDicePressed);
    _gameRef = FirebaseDatabase.instance
        .reference()
        .child("games")
        .child(_game.gameID);

    _gameRef.child("stats").onValue.listen(_onStatChange);
    _gameRef.child("secrets").onValue.listen(_onSecretChange);
  }

  _onDicePressed(int number) async {
    if (currUserStatus == CurrUserStatus.BAT) {
      request(HttpMethod.POST, "/game/${_game.gameID}/bat",
          body: {"num": number});
    } else if (currUserStatus == CurrUserStatus.BOWL) {
      request(HttpMethod.POST, "/game/${_game.gameID}/bowl",
          body: {"num": number});
    }
    dice.mState.disable(); // Only 1 press allowed
  }

  showAlertDialog(BuildContext context, String message) {
    Widget remindButton = FlatButton(
      child: Text("Back to home page"),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameHomePage()),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.amberAccent,
      title: Text(
        "GAME OVER",
        style: TextStyle(
          color: Colors.black,
          fontSize: 45,
          fontFamily: primaryfont,
        ),
      ),
      content: Text(
        "$message",
        style: TextStyle(
          color: Colors.black,
          fontSize: 45,
          fontFamily: primaryfont,
        ),
      ),
      actions: [
        remindButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onStatChange(Event event) async {
    // Last thing that is updated in the server -- this means that everything has been done by the server for this round
    snapshot = await _gameRef.once();

    //disable dice buttons
    dice.mState.disable();

    int batHand = snapshot.value["hands"]["bat"];
    int bowlHand = snapshot.value["hands"]["bowl"];
    bool redBatting = snapshot.value["redBatting"];

    if (batHand != -1 && bowlHand != -1) {
      if (redBatting)
        hands.mState.setHands(batHand, bowlHand);
      else
        hands.mState.setHands(bowlHand, batHand);
      await Future.delayed(
          Duration(seconds: 3)); // sleep for 3 seconds after setting hands
    }

    titleBar.mState.setStatus(redBatting);
    List<UserStat> redStats = new List();
    List<UserStat> blueStats = new List();
    List<String> redPlayers =
        new List<String>.from(snapshot.value["teams"]["red"]);
    List<String> bluePlayers =
        new List<String>.from(snapshot.value["teams"]["blue"]);
    Map<String, dynamic> players =
        Map<String, dynamic>.from(snapshot.value["players"]);

    for (var uid in players.keys) {
      User user = await _userCache.get(uid);
      if (redPlayers.contains(uid))
        redStats.add(
            new UserStat(user, players[uid]["runs"], players[uid]["wickets"]));
      else
        blueStats.add(
            new UserStat(user, players[uid]["runs"], players[uid]["wickets"]));
    }

    teamPlayersList.mState.setPlayerStats(redStats, blueStats);
    User currRedPlayer = await _userCache.get(redPlayers[0]);
    User currBlueUser = await _userCache.get(bluePlayers[0]);
    currPlayer.mState.setPlayers(currRedPlayer, currBlueUser);

    // show top and bottom stats
    GameStat gStats = new GameStat(
        snapshot.value["stats"]["runs"],
        snapshot.value["stats"]["balls"],
        snapshot.value["stats"]["wickets"],
        snapshot.value["stats"]["target"]);

    topStats.mState.setStat(gStats.score(), gStats.overs());
    bottomStats.mState.setStat(gStats.target(), gStats.toWin());

    if (snapshot.value["message"] != null) {
      showAlertDialog(context, snapshot.value["message"]);
    }

    //enable buttons if this user is batter or bowler
    if ((_self.uid == redPlayers[0] && redBatting) ||
        (_self.uid == bluePlayers[0] && !redBatting)) {
      currUserStatus = CurrUserStatus.BAT;
      dice.mState.enable();
    } else if ((_self.uid == redPlayers[0] && !redBatting) ||
        (_self.uid == bluePlayers[0] && redBatting)) {
      currUserStatus = CurrUserStatus.BOWL;
      dice.mState.enable();
    } else {
      currUserStatus = CurrUserStatus.VIEWER;
    }
  }

  _onSecretChange(Event event) {
    if(currUserStatus != CurrUserStatus.BAT || event.snapshot.value["bat"] == -1 || event.snapshot.value["bowl"] == -1){
      return;
    }
    // Call update endpoint
    request(HttpMethod.POST, "/game/${_game.gameID}/update");
  }
}
