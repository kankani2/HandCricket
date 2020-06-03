import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  int imageId;

  User(String name, int imageId) {
    this.name = name;
    this.imageId = imageId;
  }

  void storeUserInfoToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
    prefs.setInt("imageId", imageId);
  }

  static Future<User> getUserInfoFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return new User(prefs.getString("name"), prefs.getInt("imageId"));
  }
}
