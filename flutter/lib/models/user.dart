import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String uid;
  String name;
  int icon;

  User(this.uid, this.name, this.icon);

  void storeUserInfoToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    prefs.setString("name", name);
    prefs.setInt("icon", icon);
  }

  static Future<User> getUserInfoFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return new User(
        prefs.getString("uid"), prefs.getString("name"), prefs.getInt("icon"));
  }

  static Future<User> getUser(
      String uid, GlobalKey<ScaffoldState> scaffoldKey) async {
    var response = await request(HttpMethod.GET, "/user/$uid");
    if (!isSuccess(response)) {
      final snackBar =
          SnackBar(content: Text('User not found in the database.'));
      scaffoldKey.currentState.showSnackBar(snackBar);
      return null;
    }
    Map respBody = json.decode(response.body);
    return User(uid, respBody["name"], respBody["icon"]);
  }
}
