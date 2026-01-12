import 'package:flutter/material.dart';
import '../models/transaction.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const StatisticsScreen({super.key, required this.transactions});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedFilter = "Day";
  final List<String> _periodFilters = ["Day", "Week"];

  final List<String> _categoryNames = [
    "Food",
    "Shopping",
    "Transport",
    "Bills",
    "Entertainment",
    "Health",
    "Other",
  ];

  double _calculateCategoryTotal(String category) {
    double total = 0;
    for (var tx in widget.transactions) {
      if (tx.title.toLowerCase().contains(category.toLowerCase())) {
        String cleanAmount = tx.amount.replaceAll(RegExp(r'[^\d.]'), '');
        total += double.tryParse(cleanAmount) ?? 0;
      }
    }
    return total;
  }

  double _calculateDailyTotal(DateTime date) {
    double total = 0;
    for (var tx in widget.transactions) {
      if (tx.date.year == date.year &&
          tx.date.month == date.month &&
          tx.date.day == date.day) {
        String cleanAmount = tx.amount.replaceAll(RegExp(r'[^\d.]'), '');
        total += double.tryParse(cleanAmount) ?? 0;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categoryData = [];
    for (var cat in _categoryNames) {
      double total = _calculateCategoryTotal(cat);
      if (total > 0) {
        categoryData.add({
          "name": cat == "Food" ? "Food & Drinks" : cat,
          "amount": total,
          "icon": _getCategoryIcon(cat),
          "color": _getCategoryColor(cat),
        });
      }
    }

    categoryData.sort((a, b) => b["amount"].compareTo(a["amount"]));
    final top3Categories = categoryData.take(3).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Statistics",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _periodFilters.map((period) {
                    bool isSelected = _selectedFilter == period;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = period),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00897B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          period,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _selectedFilter == "Day"
                      ? _buildDayBars()
                      : _buildWeekBars(),
                ),
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Top Categories",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: top3Categories.map((data) {
                      return _buildCategoryCard(
                        data['name'],
                        data['amount'],
                        data['icon'],
                        data['color'],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDayBars() {
    final now = DateTime.now();
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));
    List<Widget> bars = [];
    List<String> labels = ["M", "T", "W", "T", "F", "S", "S"];

    for (int i = 0; i < 7; i++) {
      DateTime barDate = currentMonday.add(Duration(days: i));
      double dailyAmount = _calculateDailyTotal(barDate);
      bool isToday =
          barDate.year == now.year &&
          barDate.month == now.month &&
          barDate.day == now.day;

      double barHeight = (dailyAmount / 200) * 100;
      if (barHeight > 100) barHeight = 100;
      if (barHeight < 5 && dailyAmount > 0) barHeight = 10;

      bars.add(
        _buildBar(
          barHeight,
          isToday,
          labels[i],
          "\$${dailyAmount.toStringAsFixed(0)}",
        ),
      );
    }
    return bars;
  }

  List<Widget> _buildWeekBars() {
    final now = DateTime.now();
    List<Widget> bars = [];
    for (int i = 0; i < 4; i++) {
      int startDay = (i * 7) + 1;
      int endDay = (i + 1) * 7;
      double weeklyTotal = 0;
      for (int d = startDay; d <= endDay; d++) {
        DateTime date = DateTime(now.year, now.month, d);
        weeklyTotal += _calculateDailyTotal(date);
      }
      double barHeight = (weeklyTotal / 1000) * 100;
      bars.add(
        _buildBar(
          barHeight,
          (now.day >= startDay && now.day <= endDay),
          "W${i + 1}",
          "\$${weeklyTotal.toStringAsFixed(0)}",
        ),
      );
    }
    return bars;
  }

  Widget _buildBar(
    double height,
    bool isSelected,
    String label,
    String amount,
  ) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF00897B) : Colors.grey[400],
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 15,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF00897B).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            heightFactor: height / 100,
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected || height > 10
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF00897B),
                          Color.fromARGB(255, 0, 255, 229),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )
                    : null,
                color: isSelected || height > 10
                    ? null
                    : const Color(0xFF00897B).withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    double amount,
    IconData icon,
    Color iconBg,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00897B), size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
          ),
          Text(
            "-\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains("Food")) return Icons.restaurant;
    if (category.contains("Shopping")) return Icons.shopping_bag;
    if (category.contains("Transport")) return Icons.directions_car;
    if (category.contains("Bills")) return Icons.receipt_long;
    if (category.contains("Entertainment")) return Icons.movie;
    if (category.contains("Health")) return Icons.local_hospital;
    return Icons.more_horiz;
  }

  Color _getCategoryColor(String category) {
    if (category.contains("Food")) return const Color(0xFFE0F2F1);
    if (category.contains("Shopping")) return const Color(0xFFF3E5F5);
    if (category.contains("Transport")) return const Color(0xFFE1F5FE);
    if (category.contains("Bills")) return const Color(0xFFFFF3E0);
    if (category.contains("Entertainment")) return const Color(0xFFFCE4EC);
    if (category.contains("Health")) return const Color(0xFFFFEBEE);
    return const Color(0xFFEEEEEE);
  }
}
