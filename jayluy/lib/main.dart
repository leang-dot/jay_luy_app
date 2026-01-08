import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';

// Import State and Local Storage to load data
import 'state/app_state.dart';
import 'data/local_storage.dart'; 

void main() async {
  // 1. Required for Async operations (loading storage) before app starts
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load Transactions from Local Storage
  List<dynamic> loadedTransactions = await LocalStorage.loadTransactions();
  if (loadedTransactions.isNotEmpty) {
    // If we have saved data, use it!
    globalTransactions = loadedTransactions.cast<dynamic>().map((e) => e as dynamic).toList().cast();
    // (Note: Due to generic list types, simpler is usually:)
    // globalTransactions = await LocalStorage.loadTransactions();
    // But since I typed loadTransactions specifically in the previous step:
    globalTransactions = await LocalStorage.loadTransactions();
  } else {
    // If storage is empty (First run), load the Mock Data
    globalTransactions = []; 
    // OR if you want default mock data on fresh install:
    // globalTransactions = Transaction.mockTransactions;
  }

  // 3. Load User (if logged in previously)
  currentUser = await LocalStorage.loadUser();

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

      // FIX: Ensure the app starts at WelcomeScreen
      home: const WelcomeScreen(), 

      routes: {
        // Define route names for clear navigation
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