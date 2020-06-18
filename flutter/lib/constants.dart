import 'package:flutter/material.dart';
import 'package:handcricket/models/team.dart';

final iconMap = {
  0: "images/icons/icons8-crane-bird-50.png",
  1: "images/icons/icons8-ant-50.png",
  2: "images/icons/icons8-bee-50.png",
  3: "images/icons/icons8-dragon-50.png",
  4: "images/icons/icons8-grasshopper-50.png",
  5: "images/icons/icons8-ladybird-50.png",
  6: "images/icons/icons8-parrot-50.png",
  7: "images/icons/icons8-swan-50.png",
  8: "images/icons/icons8-tiger-butterfly-50.png",
};

final handMap = {
  "red": {
    0: "images/hands/r0.png",
    1: "images/hands/r1.png",
    2: "images/hands/r2.png",
    3: "images/hands/r3.png",
    4: "images/hands/r4.png",
    5: "images/hands/r5.png",
    6: "images/hands/r6.png",
  },
  "blue": {
    0: "images/hands/b0.png",
    1: "images/hands/b1.png",
    2: "images/hands/b2.png",
    3: "images/hands/b3.png",
    4: "images/hands/b4.png",
    5: "images/hands/b5.png",
    6: "images/hands/b6.png",
  }
};

// NOTE: red must always be index 0. In the app, red is always displayed on the
// left and blue on the right.
final teamMapping = {
  0: Team("red", Colors.red[700]),
  1: Team("blue", Colors.blue[900]),
};

const String primaryfont = "BalsamiqSans";
final Color primaryColor = Colors.blue[300];
const String appName = "Hand Cricket";
const int codeWordLength = 8;
const int maxNameLength = 8;
