import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/utils/backend.dart';

class CreateGamePage extends StatefulWidget {
  @override
  _CreateGamePage createState() => _CreateGamePage();
}

class _CreateGamePage extends State<CreateGamePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');
  List<User> players = new List<User>();
  String code = "";

  void initState() {
    super.initState();
    GameInfo.getGameInfoFromDisk().then((game) async {
      addListenerForGameToUpdatePlayers(game);
      setState(() {
        code = game.gameCode;
      });
    });
  }

  List<Expanded> getGameCodeWidgets(String code) {
    List<Expanded> codeWord = new List<Expanded>();
    for (int i = 0; i < code.length; i++) {
      if (code[i] == " ") {
        codeWord.add(
          Expanded(
            child: Text(' '),
          ),
        );
        continue;
      }
      codeWord.add(
        Expanded(
          child: new Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 3.0,
                ),
              ),
            ),
            child: Text(
              code[i],
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ),
      );
    }
    return codeWord;
  }

  List<Container> getPlayerWidgets(List<User> players) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'CODE:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: primaryfont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getGameCodeWidgets(code),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Players:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: primaryfont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: getPlayerWidgets(players),
                ),
              ),
              FlatButton(
                color: Colors.blue[700],
                onPressed: moveToTeamMatch,
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToTeamMatch() async {
    var gameInfo = await GameInfo.getGameInfoFromDisk();
    var response =
        await request(HttpMethod.POST, "/game/${gameInfo.gameID}/match");
    if (!isSuccess(response)) {
      final snackBar =
          SnackBar(content: Text('Could not move to team matching stage.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    // TODO: Navigate to team matching stage.
  }

  Future<User> getUserFromID(String uid) async {
    var response = await request(HttpMethod.GET, "/user/$uid");
    if (!isSuccess(response)) {
      final snackBar =
          SnackBar(content: Text('User could not be created in the database.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return null;
    }
    Map respBody = json.decode(response.body);
    return User(uid, respBody["name"], respBody["icon"]);
  }

  void addListenerForGameToUpdatePlayers(GameInfo game) {
    _gamesRef
        .child(game.gameID)
        .child("players")
        .onChildAdded
        .listen((event) async {
      User playerInfo = await getUserFromID(event.snapshot.key);
      setState(() {
        players.add(playerInfo);
      });
    });
  }
}
