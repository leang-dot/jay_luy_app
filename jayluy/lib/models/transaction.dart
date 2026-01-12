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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'iconCode': icon.codePoint, 
      'colorValue': iconBgColor.value, 
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      amount: json['amount'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'), 
      iconBgColor: Color(json['colorValue']),
      date: DateTime.parse(json['date']),
    );
  }

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
}