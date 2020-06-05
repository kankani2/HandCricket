import 'package:shared_preferences/shared_preferences.dart';

class User {
  String uid;
  String name;
  int icon;

  User(String uid, String name, int icon) {
    this.uid = uid;
    this.name = name;
    this.icon = icon;
  }

  void storeUserInfoToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    prefs.setString("name", name);
    prefs.setInt("icon", icon);
  }

  static Future<User> getUserInfoFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return new User(prefs.getString("uid"), prefs.getString("name"), prefs.getInt("icon"));
  }
}
