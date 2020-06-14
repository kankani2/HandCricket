import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/utils/cache.dart';

class PlayerListWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Cache<User> userCache;

  PlayerListWidget(
      {Key key, @required this.scaffoldKey, @required this.userCache})
      : super(key: key);

  @override
  _PlayerListWidgetState createState() =>
      _PlayerListWidgetState(scaffoldKey, userCache);
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  List<User> _players = new List<User>();
  GlobalKey<ScaffoldState> _scaffoldKey;
  Cache<User> _userCache;
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');

  _PlayerListWidgetState(this._scaffoldKey, this._userCache);

  @override
  void initState() {
    super.initState();
    GameInfo.getGameInfoFromDisk().then((game) async {
      addListenerForGameToUpdatePlayers(game);
    });
  }

  void addListenerForGameToUpdatePlayers(GameInfo game) {
    _gamesRef
        .child(game.gameID)
        .child("players")
        .onChildAdded
        .listen((event) async {
      User player = await _userCache.get(event.snapshot.key);
      if (player == null) {
        User.userNotFoundError(_scaffoldKey, event.snapshot.key);
        return;
      }

      setState(() {
        _players.add(player);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: getPlayerNameWidgets(_players),
      ),
    );
  }

  static List<Container> getPlayerNameWidgets(List<User> players) {
    List<Container> playerContainers = new List<Container>();
    if (players == null) return playerContainers;
    for (int i = 0; i < players.length; i++) {
      playerContainers.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[300],
          ),
          child: Text(
            players[i].name,
            style: TextStyle(fontSize: 25.0),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return playerContainers;
  }
}
