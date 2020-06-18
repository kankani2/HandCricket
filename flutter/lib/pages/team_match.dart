import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/utils/cache.dart';
import 'package:handcricket/utils/error.dart';
import 'package:handcricket/widgets/player_team_select.dart';
import 'package:http/http.dart';

import 'main/game.dart';

class TeamMatchPage extends StatefulWidget {
  final Cache<User> userCache;

  const TeamMatchPage({Key key, @required this.userCache}) : super(key: key);

  @override
  _TeamMatchPageState createState() => _TeamMatchPageState(userCache);
}

class _TeamMatchPageState extends State<TeamMatchPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');
  List<PlayerTeamSelectWidget> _playerContainers =
      new List<PlayerTeamSelectWidget>();
  Cache<User> _userCache;
  GameInfo _game;

  _TeamMatchPageState(this._userCache);

  @override
  void initState() {
    super.initState();
    addListenerForGameToUpdatePlayers();
  }

  void addListenerForGameToUpdatePlayers() async {
    _game = await GameInfo.getGameInfoFromDisk();
    DataSnapshot snapshot =
        await _gamesRef.child(_game.gameID).child("players").once();
    Map<String, dynamic> playerUIDs =
        new Map<String, dynamic>.from(snapshot.value);

    List<User> players = new List();
    for (String uid in playerUIDs.keys) {
      var player = await _userCache.get(uid);
      if (player == null) {
        User.userNotFoundError(_scaffoldKey, uid);
        continue;
      }
      players.add(player);
    }

    setState(() {
      _playerContainers = new List<PlayerTeamSelectWidget>();
      for (int i = 0; i < players.length; i++) {
        _playerContainers.add(PlayerTeamSelectWidget(
          player: players[i],
          group: i % teamMapping.length,
        ));
      }
    });
  }

  onTeamMatchDone() async {
    Map<String, dynamic> body = new Map();
    teamMapping.forEach((index, team) {
      body[team.name] = new List<String>();
    });
    _playerContainers.forEach((container) {
      body[container.getTeamName()].add(container.getUID());
    });

    Response response = await request(
        HttpMethod.POST, "/game/${_game.gameID}/start",
        body: body);
    if (!isSuccess(response)) {
      errorMessage(_scaffoldKey, 'Could not start game.');
      return;
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainGamePage(
                  userCache: _userCache,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        padding: EdgeInsets.fromLTRB(20, 80, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pick teams',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 45,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: _playerContainers,
              ),
            ),
            FlatButton(
              color: blackColor,
              onPressed: onTeamMatchDone,
              child: Text(
                'Done',
                style: TextStyle(
                  color: yellowColor,
                  fontSize: 40,
                  fontFamily: primaryfont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
