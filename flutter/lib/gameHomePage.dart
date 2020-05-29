import 'package:flutter/material.dart';
import 'package:handcricket/changeSettingsPage.dart';
import 'package:handcricket/user.dart';
import 'package:flutter/widgets.dart';

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
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
                        fontFamily: 'BalsamiqSans',
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
                        fontFamily: 'BalsamiqSans',
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
          User.getCurrUserIconFromDisk().then((icon) {
            User.getCurrUserNameFromDisk().then((name) {
              User currUser = User(name, icon);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeSettingsPage(
                          currUser: currUser,
                        )),
              );
              print("user name: ${currUser.name}");
              print("user image id: ${currUser.imageId}");
            });
          });
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
