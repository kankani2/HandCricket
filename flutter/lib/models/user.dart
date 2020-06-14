import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handcricket/utils/backend.dart';
import 'package:handcricket/utils/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String uid;
  String name;
  int icon;

  User(this.uid, this.name, this.icon);

  void storeUserToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    prefs.setString("name", name);
    prefs.setInt("icon", icon);
  }

  static Future<User> getUserFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return new User(
        prefs.getString("uid"), prefs.getString("name"), prefs.getInt("icon"));
  }

  static Future<User> getUser(String uid) async {
    var response = await request(HttpMethod.GET, "/user/$uid");
    if (!isSuccess(response)) {
      return null;
    }

    Map respBody = json.decode(response.body);
    return User(uid, respBody["name"], respBody["icon"]);
  }

  static void userNotFoundError(
      GlobalKey<ScaffoldState> scaffoldKey, String uid) {
    errorMessage(scaffoldKey, 'User $uid not found in the database.');
  }
}
