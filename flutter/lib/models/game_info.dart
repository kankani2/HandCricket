import 'package:shared_preferences/shared_preferences.dart';

class GameInfo {
  String gameID;
  String gameCode;

  GameInfo(this.gameCode, this.gameID);

  void storeGameInfoToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("gameID", gameID);
    prefs.setString("gameCode", gameCode);
  }

  static Future<GameInfo> getGameInfoFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return new GameInfo(prefs.getString("gameCode"), prefs.getString("gameID"));
  }
}
