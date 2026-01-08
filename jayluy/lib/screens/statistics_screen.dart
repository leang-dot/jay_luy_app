import 'package:flutter/material.dart';
import '../state/app_state.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedFilter = "Day"; 
  final List<String> _periodFilters = ["Day", "Week"];

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 10),

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
                      onTap: () {
                        setState(() {
                          _selectedFilter = period;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00897B) : Colors.transparent,
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
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10), 
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _selectedFilter == "Day" 
                        ? _buildDayBars()
                        : _buildWeekBars(),
                    ),
                  ],
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
                    children: [
                      _buildCategoryItem("Food & Drinks", "\$${calculateTotalExpenses(category: 'Food').toStringAsFixed(2)}", Icons.restaurant, 0.7),
                      _buildCategoryItem("Transport", "\$${calculateTotalExpenses(category: 'Transport').toStringAsFixed(2)}", Icons.directions_car, 0.3),
                      _buildCategoryItem("Shopping", "\$${calculateTotalExpenses(category: 'Shopping').toStringAsFixed(2)}", Icons.shopping_bag, 0.9),
                      const SizedBox(height: 20),
                    ],
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
      
      double dailyAmount = calculateDailyTotal(barDate);
      
      bool isToday = barDate.year == now.year && 
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
          "\$${dailyAmount.toStringAsFixed(0)}"
        )
      );
    }
    return bars;
  }

  List<Widget> _buildWeekBars() {
    final now = DateTime.now();
    List<Widget> bars = [];
    
    for(int i = 0; i < 4; i++) {
      int startDay = (i * 7) + 1;
      int endDay = (i + 1) * 7;
      
      int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      if (i == 3) endDay = daysInMonth; 

      double weeklyTotal = 0;
      
      for(int d = startDay; d <= endDay; d++) {
        if (d > daysInMonth) break;
        DateTime date = DateTime(now.year, now.month, d);
        weeklyTotal += calculateDailyTotal(date);
      }

      bool isCurrentWeek = (now.day >= startDay && now.day <= endDay);

      double barHeight = (weeklyTotal / 1000) * 100;
      if (barHeight > 100) barHeight = 100;
      if (barHeight < 5 && weeklyTotal > 0) barHeight = 10;

      bars.add(
        _buildBar(
          barHeight, 
          isCurrentWeek, 
          "W${i + 1}", 
          "\$${weeklyTotal.toStringAsFixed(0)}"
        )
      );
    }
    return bars;
  }

  Widget _buildBar(double height, bool isSelected, String label, String amount) {
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
                color: isSelected ? const Color(0xFF00897B) : const Color(0xFF00897B).withOpacity(0.4),
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

  Widget _buildCategoryItem(String title, String amount, IconData icon, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00897B)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[100],
                  color: const Color(0xFF00897B),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}