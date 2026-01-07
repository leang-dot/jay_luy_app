import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  
  // [NEW] We now store the REAL date and time
  final DateTime date; 

  Transaction({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.date,
  });

  // [HELPER] This converts the real DateTime into a nice string for your UI
  // Example output: "Today, 10:30 AM" or "Mon, 4:00 PM"
  String get timeFormatted {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday = date.year == now.year && date.month == now.month && date.day == now.day - 1;
    
    String hour = date.hour > 12 ? '${date.hour - 12}' : '${date.hour}';
    String period = date.hour >= 12 ? 'PM' : 'AM';
    String minute = date.minute.toString().padLeft(2, '0');
    String timeStr = "$hour:$minute $period";

    if (isToday) return "Today, $timeStr";
    if (isYesterday) return "Yesterday, $timeStr";
    
    // Fallback for older dates: "Mon, 10:00 AM"
    List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    String weekDay = weekDays[date.weekday - 1];
    return "$weekDay, $timeStr";
  }

  // [UPDATED] Mock Data using DateTime.now() so it works dynamically!
  static List<Transaction> get mockTransactions {
    final now = DateTime.now();
    
    return [
      Transaction(
        title: "Coffee", 
        amount: "-\$5.00", 
        icon: Icons.coffee, 
        iconBgColor: const Color(0xFFE0F2F1),
        date: DateTime(now.year, now.month, now.day, 10, 0), // Today 10:00 AM
      ),
      Transaction(
        title: "Lunch", 
        amount: "-\$12.50", 
        icon: Icons.restaurant, 
        iconBgColor: const Color(0xFFFFF3E0),
        date: DateTime(now.year, now.month, now.day, 13, 0), // Today 1:00 PM
      ),
      Transaction(
        title: "Transport", 
        amount: "-\$3.00", 
        icon: Icons.directions_car, 
        iconBgColor: const Color(0xFFE1F5FE),
        date: DateTime(now.year, now.month, now.day, 17, 30), // Today 5:30 PM
      ),
      Transaction(
        title: "Netflix", 
        amount: "-\$15.99", 
        icon: Icons.movie, 
        iconBgColor: const Color(0xFFFCE4EC),
        date: now.subtract(const Duration(days: 1)), // Yesterday (same time as now)
      ),
      Transaction(
        title: "Groceries", 
        amount: "-\$45.00", 
        icon: Icons.shopping_cart, 
        iconBgColor: const Color(0xFFF3E5F5),
        date: now.subtract(const Duration(days: 2)), // 2 Days ago
      ),
    ];
  }
}