import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/gameHomePage.dart';
import 'package:handcricket/selectIcon.dart';
import 'package:handcricket/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  User.getCurrUserNameFromDisk().then((name) {
    User.getCurrUserIconFromDisk().then((icon) {
      if (name != null && icon != null) {
        runApp(MyAppHomepage());
      } else {
        runApp(MyAppFirstTime());
      }
    });
  });
}

class MyAppFirstTime extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Cricket',
      color: Colors.blue,
      home: FirstNameSettingsPage(),
    );
  }
}

class MyAppHomepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Cricket',
      color: Colors.blue,
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
    if (_textEditingController.text.isEmpty ||
        _textEditingController.text.trim().isEmpty) {
      setState(() {
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
      Navigator.push(
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
      backgroundColor: Colors.blue[300],
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
                    fontFamily: 'BalsamiqSans',
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
