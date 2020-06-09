import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/pages/game_home.dart';
import 'package:handcricket/pages/select_first_name.dart';
import 'package:handcricket/models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  User.getUserFromDisk().then((user) {
    if (user.uid == null) {
      runApp(FirstTime());
    } else {
      runApp(Homepage());
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
      home: SelectFirstNamePage(),
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
