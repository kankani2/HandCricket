import 'package:flutter/material.dart';
import 'package:handcricket/constants.dart';

class TeamMatchPage extends StatefulWidget {
  @override
  _TeamMatchPageState createState() => _TeamMatchPageState();
}

class _TeamMatchPageState extends State<TeamMatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text('Team match page'),
        ),
      ),
    );
  }
}
