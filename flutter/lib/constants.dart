import 'package:flutter/material.dart';
import 'package:handcricket/models/team.dart';

final iconMap = {
  0: "images/icons8-crane-bird-50.png",
  1: "images/icons8-ant-50.png",
  2: "images/icons8-bee-50.png",
  3: "images/icons8-dragon-50.png",
  4: "images/icons8-grasshopper-50.png",
  5: "images/icons8-ladybird-50.png",
  6: "images/icons8-parrot-50.png",
  7: "images/icons8-swan-50.png",
  8: "images/icons8-tiger-butterfly-50.png",
};

final teamMapping = {
  0: Team("redTeam", Colors.red),
  1: Team("blueTeam", Colors.blue[900]),
};

const String primaryfont = "BalsamiqSans";
final Color primaryColor = Colors.blue[300];
const String appName = "Hand Cricket";
const int codeWordLength = 8;
