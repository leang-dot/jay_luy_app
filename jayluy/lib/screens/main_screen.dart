import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';
import 'welcome_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1. Define the pages (Recreated every time build runs)
    final List<Widget> pages = [
      const HomeScreen(), 
      
      AddExpenseScreen(onSave: () {
        setState(() {
          _selectedIndex = 0; // Triggers a rebuild to show Home
        });
      }),
      
      const StatisticsScreen(),
    ];

    return Scaffold(
      // 2. [FIX] Direct Page Switching (Forces Refresh)
      // We removed IndexedStack so the Home Screen rebuilds and calculates the new total.
      body: pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF00897B),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home_button_icon.svg',
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/home_button_icon.svg',
                colorFilter: const ColorFilter.mode(Color(0xFF00897B), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/add_button_icon.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/add_button_icon.svg',
                height: 32,
                colorFilter: const ColorFilter.mode(Color(0xFF00897B), BlendMode.srcIn),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/statistic_button_icon.svg',
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/statistic_button_icon.svg',
                colorFilter: const ColorFilter.mode(Color(0xFF00897B), BlendMode.srcIn),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}