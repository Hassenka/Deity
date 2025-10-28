import 'package:diety/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SessionManager {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _rememberMeKey = 'remember_me';
  static const String _phoneKey = 'remembered_phone';
  static const String _passwordKey = 'remembered_password';

  Future<void> saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userKey, user.toJson());
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userKey);
  }

  Future<void> saveCredentials(String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_passwordKey, password);
  }

  Future<Map<String, String>?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString(_phoneKey);
    final password = prefs.getString(_passwordKey);
    if (prefs.getBool(_rememberMeKey) == true &&
        phone != null &&
        password != null) {
      return {'phone': phone, 'password': password};
    }
    return null;
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_passwordKey);
  }

  Future<void> logout() async {
    await clearSession();
    await clearCredentials();
  }
}
