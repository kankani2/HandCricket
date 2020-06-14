import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

errorMessage(GlobalKey<ScaffoldState> scaffoldKey, String text) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
}
