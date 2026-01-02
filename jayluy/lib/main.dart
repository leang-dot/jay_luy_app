import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/profile_screen.dart';

void main(){
  runApp(const JayLuyApp());
}

class JayLuyApp extends StatelessWidget {
  const JayLuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jay Luy',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.teal,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/signup': (context) => const SignupScreen(),
        // '/home': (context) => const HomeScreen(),
        // '/add_expense': (context) => const AddExpenseScreen(),
        // '/statistics': (context) => const StatisticsScreen(),
        // '/transactions': (context) => const TransactionListScreen(),
        // '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}