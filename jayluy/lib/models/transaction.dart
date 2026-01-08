import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconBgColor;
  final DateTime date; 

  Transaction({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.date,
  });

  // --- NEW: JSON SERIALIZATION FOR LOCAL STORAGE ---

  // 1. Convert Transaction object to JSON Map (Save)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      // We store the integer ID of the icon
      'iconCode': icon.codePoint, 
      // We store the integer value of the color
      'colorValue': iconBgColor.value, 
      'date': date.toIso8601String(),
    };
  }

  // 2. Create Transaction object from JSON Map (Load)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      amount: json['amount'],
      // Reconstruct IconData from integer
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'), 
      // Reconstruct Color from integer
      iconBgColor: Color(json['colorValue']),
      date: DateTime.parse(json['date']),
    );
  }

  // --- EXISTING HELPERS ---

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
    
    List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    String weekDay = weekDays[date.weekday - 1];
    return "$weekDay, $timeStr";
  }

  static List<Transaction> get mockTransactions {
    final now = DateTime.now();
    return [
      Transaction(
        title: "Coffee", 
        amount: "-\$5.00", 
        icon: Icons.coffee, 
        iconBgColor: const Color(0xFFE0F2F1),
        date: DateTime(now.year, now.month, now.day, 10, 0),
      ),
      Transaction(
        title: "Lunch", 
        amount: "-\$12.50", 
        icon: Icons.restaurant, 
        iconBgColor: const Color(0xFFFFF3E0),
        date: DateTime(now.year, now.month, now.day, 13, 0),
      ),
      Transaction(
        title: "Transport", 
        amount: "-\$3.00", 
        icon: Icons.directions_car, 
        iconBgColor: const Color(0xFFE1F5FE),
        date: DateTime(now.year, now.month, now.day, 17, 30),
      ),
    ];
  }
}