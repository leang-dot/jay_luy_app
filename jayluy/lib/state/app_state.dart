import '../models/transaction.dart'; // [FIX] Ensure this import matches your file name
import '../models/user.dart';
// 1. GLOBAL LIST OF TRANSACTIONS
List<Transaction> globalTransactions = Transaction.mockTransactions;

// 2. CURRENT USER (Manage User State)
User? currentUser; // This will hold the user data after login

// 2. CALCULATE TOTAL EXPENSES (For the Big Card)
double calculateTotalExpenses({String? category}) {
  double total = 0;

  for (var tx in globalTransactions) {
    // If a category is specified, skip transactions that don't match
    if (category != null && !tx.title.contains(category) && category != "All") {
      continue;
    }

    // [CRITICAL] Clean the string before parsing
    // Remove '$', '-', and ',' so "-$1,200.50" becomes "1200.50"
    String cleanAmount = tx.amount
        .replaceAll(RegExp(r'[^\d.]'), ''); // Keeps only numbers and dots

    double? amount = double.tryParse(cleanAmount);
    if (amount != null) {
      total += amount;
    }
  }

  return total;
}

// 3. CALCULATE DAILY TOTAL (For the Chart)
double calculateDailyTotal(DateTime date) {
  double total = 0;

  for (var tx in globalTransactions) {
    // Check if the date matches (Year, Month, Day)
    if (tx.date.year == date.year &&
        tx.date.month == date.month &&
        tx.date.day == date.day) {
      
      String cleanAmount = tx.amount.replaceAll(RegExp(r'[^\d.]'), '');
      double? amount = double.tryParse(cleanAmount);
      
      if (amount != null) {
        total += amount;
      }
    }
  }

  return total;
}