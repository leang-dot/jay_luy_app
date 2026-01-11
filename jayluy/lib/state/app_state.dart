import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../data/local_storage.dart';

class AppState extends ChangeNotifier {
  List<Transaction> _transactions = [];
  User? _currentUser;

  List<Transaction> get transactions => _transactions;
  User? get currentUser => _currentUser;

  double calculateTotalExpenses({String? category}) {
    double total = 0;
    for (var tx in _transactions) {
      if (category != null && !tx.title.contains(category) && category != "All") {
        continue;
      }
      String cleanAmount = tx.amount.replaceAll(RegExp(r'[^\d.]'), '');
      double? amount = double.tryParse(cleanAmount);
      if (amount != null) total += amount;
    }
    return total;
  }

  double calculateDailyTotal(DateTime date) {
    double total = 0;
    for (var tx in _transactions) {
      if (tx.date.year == date.year &&
          tx.date.month == date.month &&
          tx.date.day == date.day) {
        String cleanAmount = tx.amount.replaceAll(RegExp(r'[^\d.]'), '');
        double? amount = double.tryParse(cleanAmount);
        if (amount != null) total += amount;
      }
    }
    return total;
  }

  Future<void> loadInitialData() async {
    _currentUser = await LocalStorage.loadUser();
    
    if (_currentUser != null) {
      _transactions = await LocalStorage.loadTransactions(_currentUser!.email);
    } else {
      _transactions = [];
    }
    notifyListeners();
  }

  Future<void> loginUser(User user) async {
    _currentUser = user;
    _transactions = await LocalStorage.loadTransactions(user.email);
    
    await LocalStorage.saveUser(user);
    
    notifyListeners();
  }

  void logout() async {
    _currentUser = null;
    _transactions = [];
    
    await LocalStorage.clearUser();
    notifyListeners();
  }

  void addTransaction(Transaction tx) {
    if (_currentUser == null) return;

    _transactions.insert(0, tx);

    LocalStorage.saveTransactions(_transactions, _currentUser!.email);
    notifyListeners();
  }
}