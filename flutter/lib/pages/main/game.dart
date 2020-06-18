import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/game_stat.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/models/user_stat.dart';
import 'package:handcricket/pages/main/curr_player.dart';
import 'package:handcricket/pages/main/dice.dart';
import 'package:handcricket/pages/main/hands.dart';
import 'package:handcricket/pages/main/stat.dart';
import 'package:handcricket/pages/main/team_player_list.dart';
import 'package:handcricket/pages/main/title_bar.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/utils/cache.dart';
import 'package:http/http.dart';

import '../../constants.dart';

enum CurrUserStatus { BAT, BOWL, VIEWER }

class MainGamePage extends StatefulWidget {
  final Cache<User> userCache;

  const MainGamePage({Key key, @required this.userCache}) : super(key: key);

  @override
  _MainGamePageState createState() => _MainGamePageState(userCache);
}

class _MainGamePageState extends State<MainGamePage> {
  // interactive widgets
  TitleBarWidget titleBar = TitleBarWidget();
  HandsWidget hands = HandsWidget();
  StatWidget topStats = StatWidget();
  StatWidget bottomStats = StatWidget();
  CurrPlayerWidget currPlayer = CurrPlayerWidget();
  TeamPlayerListWidget teamPlayersList = TeamPlayerListWidget();
  DiceWidget dice = DiceWidget();

  // stateful fields
  Cache<User> _userCache;
  User _self;
  CurrUserStatus _currUserStatus = CurrUserStatus.VIEWER;
  GameInfo _game;
  DatabaseReference _gameRef;

  _MainGamePageState(this._userCache);

  @override
  void initState() {
    super.initState();
    _mainRoutine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
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
    _gameRef.child("secret").onValue.listen(_onSecretChange);
  }

  _onDicePressed(int number) async {
    // Only 1 press allowed. Disable immediately after press.
    dice.mState.disable();

    if (_currUserStatus == CurrUserStatus.VIEWER) {
      return;
    }

    Response response = await request(HttpMethod.POST,
        "/game/${_game.gameID}/${describeEnum(_currUserStatus).toLowerCase()}",
        body: {"num": number});
    if (!isSuccess(response)) {
      dice.mState.enable(); // re-enable
      print(response.statusCode);
      print(response.body);
      // TODO show snack bar
    }
  }

  showAlertDialog(BuildContext context, String message) async {
    Widget remindButton = FlatButton(
      child: Text("Back to home page"),
      onPressed: () {
        Navigator.pop(context);
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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onStatChange(Event event) async {
    // Last thing that is updated in the server -- this means that everything has been done by the server for this round
    var snapshot = await _gameRef.once();

    // disable dice buttons
    dice.mState.disable();

    int batHand = snapshot.value["hands"]["bat"];
    int bowlHand = snapshot.value["hands"]["bowl"];
    bool redBatting = snapshot.value["redBatting"];

    if (batHand != -1 && bowlHand != -1) {
      if (redBatting)
        hands.mState.setHands(batHand, bowlHand);
      else
        hands.mState.setHands(bowlHand, batHand);

      // sleep for 1.5 seconds after setting hands
      await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    }

    titleBar.mState.setStatus(redBatting);
    List<UserStat> redStats = new List();
    List<UserStat> blueStats = new List();
    List<String> redPlayers =
        new List<String>.from(snapshot.value["teams"]["red"]);
    List<String> bluePlayers =
        new List<String>.from(snapshot.value["teams"]["blue"]);
    // TODO see if can directly read in Map<String, UserStat>.
    Map<String, dynamic> players =
        Map<String, dynamic>.from(snapshot.value["players"]);

    for (var uid in redPlayers) {
      User user = await _userCache.get(uid);
      redStats.add(
          new UserStat(user, players[uid]["runs"], players[uid]["wickets"]));
    }
    for (var uid in bluePlayers) {
      User user = await _userCache.get(uid);
      blueStats.add(
          new UserStat(user, players[uid]["runs"], players[uid]["wickets"]));
    }

    teamPlayersList.mState.setPlayerStats(redStats, blueStats);
    User currRedPlayer = await _userCache.get(redPlayers[0]);
    User currBluePlayer = await _userCache.get(bluePlayers[0]);
    currPlayer.mState.setPlayers(currRedPlayer, currBluePlayer);

    // show top and bottom stats
    GameStat gStats = new GameStat(
        snapshot.value["stats"]["runs"],
        snapshot.value["stats"]["balls"],
        snapshot.value["stats"]["wickets"],
        snapshot.value["stats"]["target"]);

    topStats.mState.setStat(gStats.score(), gStats.overs());
    bottomStats.mState.setStat(gStats.target(), gStats.toWin());

    if (snapshot.value["message"] != null) {
      await showAlertDialog(context, snapshot.value["message"]);
      Navigator.pop(context);
    }

    //enable buttons if this user is batter or bowler
    if ((_self.uid == currRedPlayer.uid && redBatting) ||
        (_self.uid == currBluePlayer.uid && !redBatting)) {
      _currUserStatus = CurrUserStatus.BAT;
      dice.mState.enable();
    } else if ((_self.uid == currRedPlayer.uid && !redBatting) ||
        (_self.uid == currBluePlayer.uid && redBatting)) {
      _currUserStatus = CurrUserStatus.BOWL;
      dice.mState.enable();
    } else {
      _currUserStatus = CurrUserStatus.VIEWER;
    }
  }

  _onSecretChange(Event event) async {
    if (_currUserStatus != CurrUserStatus.BAT ||
        event.snapshot.value["bat"] == -1 ||
        event.snapshot.value["bowl"] == -1) {
      return;
    }
    // Call update endpoint
    Response response =
        await request(HttpMethod.POST, "/game/${_game.gameID}/update");
    if (!isSuccess(response)) {
      // TODO show snack bar
    }
  }
}
