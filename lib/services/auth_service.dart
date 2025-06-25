import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // 🔐 Login user baru (dengan nama dan instansi saja)
  Future<bool> login(String username, String instansi) async {
    try {
      // Buat user baru dengan id unik
      final user = UserModel.create(
        username: username,
        instansi: instansi,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toMap()));
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // ✅ Mengambil data user saat ini
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  // 🔄 Update data user (misal setelah edit nama atau instansi)
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(updatedUser.toMap()));
    } catch (e) {
      print('Update user error: $e');
    }
  }

  // ❓ Cek apakah user sedang login
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Check login error: $e');
      return false;
    }
  }

  // 🚪 Logout user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
