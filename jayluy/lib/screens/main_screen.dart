import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../data/local_storage.dart';

class MainScreen extends StatefulWidget {
  final User currentUser;
  const MainScreen({super.key, required this.currentUser});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await LocalStorage.loadTransactions(widget.currentUser.email);
    setState(() {
      _transactions = data;
    });
  }

  void _handleNewTransaction(Transaction tx) async {
    setState(() {
      _transactions.insert(0, tx);
    });
    await LocalStorage.saveTransactions(
      _transactions,
      widget.currentUser.email,
    );
  }

  void _handleLogout() async {
    await LocalStorage.clearUser();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(currentUser: widget.currentUser, transactions: _transactions),
      AddExpenseScreen(
        onSave: (newTx) {
          _handleNewTransaction(newTx);
          setState(() => _selectedIndex = 0);
        },
      ),
      StatisticsScreen(transactions: _transactions),
      ProfileScreen(currentUser: widget.currentUser, onLogout: _handleLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex > 3 ? 0 : _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
