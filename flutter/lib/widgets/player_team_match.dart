import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';

class PlayerTeamMatchWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  PlayerTeamMatchWidget({Key key, @required this.scaffoldKey})
      : super(key: key);

  @override
  _PlayerTeamMatchWidgetState createState() =>
      _PlayerTeamMatchWidgetState(scaffoldKey);
}

class _PlayerTeamMatchWidgetState extends State<PlayerTeamMatchWidget> {
  List<User> players = new List<User>();
  GlobalKey<ScaffoldState> scaffoldKey;
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');
  //List<int> groupValue = new List(8);
  int group = -1;
  _PlayerTeamMatchWidgetState(this.scaffoldKey);

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
      setState(() {
        players.add(playerInfo);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: getPlayerTeamWidgets(players),
      ),
    );
  }

  List<Row> getPlayerTeamWidgets(List<User> players) {
    List<Row> playerContainers = new List<Row>();
    if (players == null) return playerContainers;
    for (int i = 0; i < players.length; i++) {
      //groupValue[i] = -1;
      playerContainers.add(
        Row(
          children: <Widget>[
            Text(
              players[i].name,
            ),
            Radio(
              value: 0,
              groupValue: group,
              onChanged: (selected) {
                print(selected);
                setState(() {
                  group = selected;
                });
              },
            ),
            Radio(
              value: 1,
              groupValue: group,
              onChanged: (selected) {
                print(selected);
                setState(() {
                  group = selected;
                });
              },
            ),
          ],
        ),
      );
    }
    return playerContainers;
  }
}
