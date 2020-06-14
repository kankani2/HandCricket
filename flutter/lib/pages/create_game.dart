import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/pages/team_match.dart';
import 'package:handcricket/utils/cache.dart';
import 'package:handcricket/utils/error.dart';
import 'package:handcricket/widgets/player_list.dart';
import 'package:handcricket/utils/backend.dart';

class CreateGamePage extends StatefulWidget {
  @override
  _CreateGamePage createState() => _CreateGamePage();
}

class _CreateGamePage extends State<CreateGamePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _userCache = new Cache<User>(User.getUser);
  String _code = "";

  void initState() {
    super.initState();
    GameInfo.getGameInfoFromDisk().then((game) async {
      setState(() {
        _code = game.gameCode;
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
                children: getGameCodeWidgets(_code),
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
              PlayerListWidget(
                scaffoldKey: _scaffoldKey,
                userCache: _userCache,
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

  Future<void> moveToTeamMatch() async {
    var gameInfo = await GameInfo.getGameInfoFromDisk();
    var response =
        await request(HttpMethod.POST, "/game/${gameInfo.gameID}/match");
    if (!isSuccess(response)) {
      errorMessage(_scaffoldKey, 'Could not move to team matching stage.');
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => TeamMatchPage(
                userCache: _userCache,
              )),
    );
  }
}
