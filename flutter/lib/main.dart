import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/game_home_page.dart';
import 'package:handcricket/select_first_name.dart';
import 'package:handcricket/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  User.getUserInfoFromDisk().then((user) {
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