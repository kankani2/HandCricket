import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handcricket/pages/join_game.dart';
import 'package:handcricket/pages/settings.dart';
import 'package:handcricket/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/pages/create_game.dart';
import 'package:handcricket/utils/error.dart';

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
        await request(HttpMethod.POST, "/game", body: {"uid": user.uid});
    if (!isSuccess(response)) {
      errorMessage(_scaffoldKey, 'Game could not be created.');
      return;
    }
    Map respBody = jsonDecode(response.body);
    GameInfo currGame = GameInfo(respBody["gameCode"], respBody["gameID"]);
    await currGame.storeGameInfoToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGamePage()),
    );
  }

  void joinGame() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinGamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: yellowColor,
                    onPressed: createGame,
                    child: Text(
                      'Create Room',
                      style: TextStyle(
                        color: blackColor,
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
                    color: blackColor,
                    onPressed: joinGame,
                    child: Text(
                      'Join Room',
                      style: TextStyle(
                        color: yellowColor,
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
        child: Icon(
          Icons.settings,
          color: yellowColor,
        ),
        backgroundColor: blackColor,
      ),
    );
  }
}
