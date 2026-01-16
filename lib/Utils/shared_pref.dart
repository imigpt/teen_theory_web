import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String isFirstLogin = "isFirstLogin";
  static const String isLoggedIn = "isLoggedIn";
  static const String userId = "userId";
  static const String accessToken = "accessToken";
  static const String userEmail = "userEmail";
  static const String fcmToken = 'fcm_token';
  static const String userTyp = "userType";
  static const String selectType = "selectType";
  static const String profileVerify = "profileVerify";
  static const String refreshToken = "refreshToken";
  static const String otpVerifyType = "otpVerifyType";
  static const String isAppFirstTimeOpenLogin = "isAppFirstTimeOpenLogin";
  static const String demo = 'demo';
  static const String tabIndex = 'tabIndex';
  static const String themeMode = 'themeMode';
  static const String conversationIdMap = 'conversationIdMap';

  static Future setStringValue(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future setBoolValue(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  static Future setIntValue(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  static Future setDoubleValue(String key, double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key)
        ? Future<String>.value(pref.getString(key))
        : Future.value("");
  }

  static Future getBoolValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key) ? pref.getBool(key) : false;
  }

  static Future getDoubleValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key) ? pref.getDouble(key) : 0.0;
  }

  static Future getIntValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(key) ? pref.getInt(key) : 0;
  }

  static Future<bool> clearAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.clear();
  }
}
