import 'package:notoli/models/user.dart';
import '../db/db_helper.dart';
import '../util/hash_password.dart';

class AuthRepo {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<bool> register(String username, String password) async {
    try {
      final hashedPassword = hashPassword(password);
      final user = User(username: username, passwordHash: hashedPassword);

      await _dbHelper.registerUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final user = await _dbHelper.getUser(username);
    if (user != null) {
      final hashedPassword = hashPassword(password);
      return user.passwordHash == hashedPassword;
    }
    return false;
  }

  Future<User?> getUser(String username) async {
    return await _dbHelper.getUser(username);
  }
}
