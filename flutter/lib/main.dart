import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/game_home_page.dart';
import 'package:handcricket/select_icon.dart';
import 'package:handcricket/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Use UID instead of checking name and imageID separately after adding server calls
  User.getUserInfoFromDisk().then((user) {
    if (user.name != null && user.imageId != null) {
      runApp(Homepage());
    } else {
      runApp(FirstTime());
    }
  });
}

class FirstTime extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      color: primaryColor,
      home: FirstNameSettingsPage(),
    );
  }
}

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      color: primaryColor,
      home: GameHomePage(),
    );
  }
}

class FirstNameSettingsPage extends StatefulWidget {
  @override
  _FirstNameSettingsPageState createState() => _FirstNameSettingsPageState();
}

class _FirstNameSettingsPageState extends State<FirstNameSettingsPage> {
  bool _validate = false;
  final _textEditingController = TextEditingController();

  void _onNameSubmit(String username) {
    if (_textEditingController.text.trim().isEmpty) {
      setState(() {
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SelectIconPage(
                  name: username,
                )),
      );
    }
  }

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
                Text(
                  'First Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontFamily: primaryfont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 70,
              child: TextField(
                controller: _textEditingController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                decoration: InputDecoration(
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                ),
                onSubmitted: _onNameSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
