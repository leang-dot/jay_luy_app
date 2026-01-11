import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class LocalStorage {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('current_user_key', userJson);
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('current_user_key');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_key');
  }

  static Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    
    String? allUsersJson = prefs.getString('all_users_db');
    Map<String, dynamic> userMap = {};
    
    if (allUsersJson != null) {
      userMap = jsonDecode(allUsersJson);
    }

    userMap[user.email] = user.toJson();

    await prefs.setString('all_users_db', jsonEncode(userMap));
  }

  static Future<User?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    String? allUsersJson = prefs.getString('all_users_db');
    
    if (allUsersJson == null) return null;

    Map<String, dynamic> userMap = jsonDecode(allUsersJson);
    
    if (userMap.containsKey(email)) {
      return User.fromJson(userMap[email]);
    }
    return null;
  }

  static Future<void> saveTransactions(List<Transaction> transactions, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      transactions.map((tx) => tx.toJson()).toList(),
    );
    await prefs.setString('transactions_$email', encodedData);
  }

  static Future<List<Transaction>> loadTransactions(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('transactions_$email');

    if (encodedData == null) return [];

    final List<dynamic> decodedList = jsonDecode(encodedData);
    return decodedList.map((item) => Transaction.fromJson(item)).toList();
  }
}