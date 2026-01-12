import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../repository/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo repo;

  AuthProvider(this.repo);

  User? _userCurrent;
  User? get userCurrent => _userCurrent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static const _keyUsername = 'session_username';

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_keyUsername);

    if (username == null) return false;

    _isLoading = true;
    notifyListeners();

    _userCurrent = await repo.getUser(username);

    if (_userCurrent == null) {
      await prefs.remove(_keyUsername);
    }

    _isLoading = false;
    notifyListeners();

    return _userCurrent != null;
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await repo.register(username, password);

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final success = await repo.login(username, password);

    if (success) {
      _userCurrent = await repo.getUser(username);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUsername, username);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);

    _userCurrent = null;
    notifyListeners();
  }
}
