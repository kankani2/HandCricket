import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/pages/main/game.dart';
import 'package:handcricket/utils/cache.dart';
import 'package:handcricket/widgets/player_list.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/models/game_info.dart';

import '../constants.dart';

class GameWaitingPage extends StatefulWidget {
  @override
  _GameWaitingPageState createState() => _GameWaitingPageState();
}

class _GameWaitingPageState extends State<GameWaitingPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _gamesRef = FirebaseDatabase.instance.reference().child('games');
  String _message = "";
  var _userCache = new Cache<User>(User.getUser);

  void initState() {
    super.initState();
    GameInfo.getGameInfoFromDisk().then((game) async {
      addListenerForGameMessage(game);
    });
  }

  void addListenerForGameMessage(GameInfo game) {
    _gamesRef.child(game.gameID).child("message").onValue.listen((event) async {
      if (event.snapshot.value == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainGamePage(
                    userCache: _userCache,
                  )),
        );
      } else {
        setState(() {
          _message = event.snapshot.value;
        });
      }
    });
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontFamily: primaryfont,
                    ),
                  ),
                ),
              ],
            ),
            PlayerListWidget(scaffoldKey: _scaffoldKey, userCache: _userCache),
          ],
        ),
      ),
    );
  }
}
