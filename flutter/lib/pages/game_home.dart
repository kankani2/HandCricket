import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handcricket/pages/join_game.dart';
import 'package:handcricket/pages/settings.dart';
import 'package:handcricket/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/pages/create_game.dart';
import 'package:http/http.dart';

import '../constants.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void createGame() async {
    var user = await User.getUserFromDisk();
    var response =
        await post(url("/game"), body: json.encode({"uid": user.uid}));
    if (!isSuccess(response)) {
      final snackBar = SnackBar(content: Text('Game could not be created.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    Map respBody = jsonDecode(response.body);
    GameInfo currGame = GameInfo(respBody["gameCode"], respBody["gameID"]);
    await currGame.storeGameInfoToDisk();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CreateGamePage()),
    );
  }

  void joinGame() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => JoinGamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Colors.blue[700],
                    onPressed: createGame,
                    child: Text(
                      'Create Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: primaryfont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Colors.blue[700],
                    onPressed: joinGame,
                    child: Text(
                      'Join Room',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: primaryfont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          User.getUserFromDisk().then((user) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        currUser: user,
                      )),
            );
          });
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
