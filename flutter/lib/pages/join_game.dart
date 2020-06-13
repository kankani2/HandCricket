import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/models/game_info.dart';
import 'package:handcricket/models/user.dart';
import 'package:handcricket/pages/game_waiting.dart';
import 'package:handcricket/utils/backend.dart';

class JoinGamePage extends StatefulWidget {
  @override
  _JoinGamePage createState() => _JoinGamePage();
}

class _JoinGamePage extends State<JoinGamePage> {
  List<TextEditingController> textControllers =
      List.generate(codeWordLength, (i) => TextEditingController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Container> getTextFields(bool secondWord) {
    int start = 0;
    int end = codeWordLength ~/ 2;
    if (secondWord) {
      start = codeWordLength ~/ 2;
      end = codeWordLength;
    }
    List<Container> containerList = new List<Container>();
    for (int i = start; i < end; i++) {
      containerList.add(
        Container(
          width: 53,
          height: 45,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: TextField(
            controller: textControllers[i],
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (String letter) {
              if (!secondWord || i != (codeWordLength - 1)) {
                if (textControllers[i].text.length == 1) {
                  FocusScope.of(context).nextFocus();
                }
              }
            },
          ),
        ),
      );
    }
    return containerList;
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
                    'ENTER CODE:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: primaryfont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getTextFields(false),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getTextFields(true),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                color: Colors.blue[700],
                onPressed: handleEnteredCode,
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

  void handleEnteredCode() async {
    var code = new StringBuffer();
    for (int i = 0; i < codeWordLength; i++) {
      if (i == codeWordLength ~/ 2) {
        code.write(" ");
      }
      code.write(textControllers[i].text);
    }
    var user = await User.getUserFromDisk();
    var response = await request(HttpMethod.POST, "/game/player/${user.uid}",
        body: {"gameCode": code.toString()});
    if (!isSuccess(response)) {
      final snackBar = SnackBar(content: Text('Game could not be joined.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    Map respBody = json.decode(response.body);
    GameInfo gameInfo = GameInfo(respBody["gameCode"], respBody["gameID"]);
    gameInfo.storeGameInfoToDisk();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameWaitingPage()),
    );
  }
}
