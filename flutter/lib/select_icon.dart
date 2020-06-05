import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/game_home_page.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/select_first_name.dart';
import 'package:handcricket/user.dart';
import 'package:handcricket/utils/backend.dart';

class SelectIconPage extends StatefulWidget {
  final String name;

  SelectIconPage({Key key, @required this.name}) : super(key: key);

  @override
  _SelectIconPageState createState() => _SelectIconPageState(name);
}

class _SelectIconPageState extends State<SelectIconPage> {
  String name;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _SelectIconPageState(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Choose Icon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontFamily: primaryfont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                  children: getListOfIconWidgets(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void iconPressed(int iconKey) async {
    var response = await request(
        HttpMethod.POST, "/user", {"name": name, "icon": iconKey});
    if (!isSuccess(response)) {
      final snackBar =
          SnackBar(content: Text('User could not be created in the database.'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    Map respBody = await readResponse(response);
    User currUser = User(respBody["uid"], name, iconKey);
    currUser.storeUserInfoToDisk();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GameHomePage()),
    );
  }

  List<IconButton> getListOfIconWidgets() {
    var listOfIconWidgets = new List<IconButton>();

    for (var key in iconMap.keys) {
      listOfIconWidgets.add(
        IconButton(
          icon: Image.asset(
            iconMap[key],
            color: Colors.white,
          ),
          iconSize: 50,
          splashColor: Colors.black,
          onPressed: () {
            iconPressed(key);
          },
        ),
      );
    }
    return listOfIconWidgets;
  }
}
