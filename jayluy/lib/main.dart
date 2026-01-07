import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const JayLuyApp());
}

class JayLuyApp extends StatelessWidget {
  const JayLuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jay Luy',
      theme: ThemeData(primarySwatch: Colors.teal),

      // FIX 1: Change 'home' to WelcomeScreen
      home: const WelcomeScreen(), 

      routes: {
        // FIX 2: Ensure MainScreen is mapped correctly
        '/home': (context) => const MainScreen(),
        '/transactions': (context) => const TransactionListScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}