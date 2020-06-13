import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamPlayerListWidget extends StatefulWidget {
  final _TeamPlayerListWidgetState mState = _TeamPlayerListWidgetState();

  @override
  State<StatefulWidget> createState() => mState;
}

class _TeamPlayerListWidgetState extends State<TeamPlayerListWidget> {
  List<Map<String, dynamic>> red;
  List<Map<String, dynamic>> blue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[],
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[],
          ),
        ),
      ],
    );
  }
}
