import 'package:flutter/material.dart';
import 'package:handcricket/change_settings_page.dart';
import 'package:handcricket/user.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () {},
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
                    onPressed: () {},
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
          User.getUserInfoFromDisk().then((user) {
            User currUser = User(user.name, user.imageId);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeSettingsPage(
                        currUser: currUser,
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
