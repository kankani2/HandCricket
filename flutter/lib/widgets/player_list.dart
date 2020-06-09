import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';

class PlayerListWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  PlayerListWidget({Key key, @required this.scaffoldKey}) : super(key: key);

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState(scaffoldKey);
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  List<User> players = new List<User>();
  GlobalKey<ScaffoldState> scaffoldKey;
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');

  _PlayerListWidgetState(this.scaffoldKey);

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
      User playerInfo = await User.getUser(event.snapshot.key, scaffoldKey);
      if (playerInfo != null) {
        setState(() {
          players.add(playerInfo);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: getPlayerNameWidgets(players),
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
