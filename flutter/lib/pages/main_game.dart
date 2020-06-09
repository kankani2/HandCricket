import 'package:flutter/material.dart';

import '../constants.dart';

class MainGamePage extends StatefulWidget {
  @override
  _MainGamePageState createState() => _MainGamePageState();
}

class _MainGamePageState extends State<MainGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text('Main page'),
        ),
      ),
    );
  }
}
