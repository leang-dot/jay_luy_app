import '../models/transaction.dart';
import '../models/user.dart';

List<Transaction> globalTransactions = Transaction.mockTransactions;

User? currentUser;

double calculateTotalExpenses({String? category}) {
  double total = 0;

  for (var tx in globalTransactions) {
    if (category != null && !tx.title.contains(category) && category != "All") {
      continue;
    }

    String cleanAmount = tx.amount
        .replaceAll(RegExp(r'[^\d.]'), '');

    double? amount = double.tryParse(cleanAmount);
    if (amount != null) {
      total += amount;
    }
  }

  return total;
}

double calculateDailyTotal(DateTime date) {
  double total = 0;

  for (var tx in globalTransactions) {
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