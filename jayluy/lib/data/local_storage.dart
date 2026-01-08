import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class LocalStorage {
  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      transactions.map((tx) => tx.toJson()).toList(),
    );
    await prefs.setString('transactions_key', encodedData);
  }

  static Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('transactions_key');

    if (encodedData == null) return [];

    final List<dynamic> decodedList = jsonDecode(encodedData);
    return decodedList.map((item) => Transaction.fromJson(item)).toList();
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user_key', userJson);
  }

  static Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_key');
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }
}