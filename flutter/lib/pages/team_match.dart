import 'package:flutter/material.dart';
import 'package:handcricket/constants.dart';
import 'package:handcricket/widgets/player_team_match.dart';

class TeamMatchPage extends StatefulWidget {
  @override
  _TeamMatchPageState createState() => _TeamMatchPageState();
}

class _TeamMatchPageState extends State<TeamMatchPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Pick teams',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: primaryfont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              PlayerTeamMatchWidget(
                scaffoldKey: _scaffoldKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
