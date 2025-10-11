import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys
  static const String isLoggedInKey = 'isLoggedIn';

  static const String userTokenKey = 'userToken';
  // static const String savedOtpKey = 'savedOtp';
  static const String userEmailKey = 'userEmail';
  // static const String userMobileKey = 'userMobile';

  // Save login status
  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, value);
  }

  // Get login status
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  // // Save user name
  // static Future<bool> setUserName(String userName) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userNameKey, userName);
  // }

  // // Save user name
  // static Future<bool> setDataWithKeyName(
  //     {required String key, String? value}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(key, value ?? "");
  // }

  // // Get Data with KeyName (nullable-safe for UI rendering)
  // static Future<String?> getDataWithKeyName({required String key}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(key);
  // }

  // // Get user name (nullable-safe for UI rendering)
  // static Future<String?> getUserName() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(userNameKey);
  // }

  // // Save user ID
  // static Future<bool> setUserId(String userId) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userIdKey, userId);
  // }

  // // Get user ID
  // static Future<String> getUserId() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(userIdKey) ?? '';
  // }

  // Save user token
  static Future<void> setUserToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userTokenKey, token);
  }

  // Get user token
  static Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTokenKey);
  }

  // Save OTP for verification
  // static Future<bool> saveOtp(String otp) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(savedOtpKey, otp);
  // }

  // Get saved OTP
  // static Future<String?> getOtp() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(savedOtpKey);
  // }

  // Save user email
  static Future<bool> setUserEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, email);
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Save user mobile
  // static Future<bool> setUserMobile(String mobile) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userMobileKey, mobile);
  // }

  // Get user mobile
  // static Future<String?> getUserMobile() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(userMobileKey);
  // }

  // Clear all saved data (for logout)
  static Future<bool> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }

  // Remove user email (for logout)
  static Future<bool> removeUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(userEmailKey);
  }

  // Get login status
  static Future<bool> getLoggedInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }
}
