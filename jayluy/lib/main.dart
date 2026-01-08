import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'state/app_state.dart';
import 'data/local_storage.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<dynamic> loadedTransactions = await LocalStorage.loadTransactions();
  if (loadedTransactions.isNotEmpty) {
    globalTransactions = loadedTransactions.cast<dynamic>().map((e) => e as dynamic).toList().cast();
    globalTransactions = await LocalStorage.loadTransactions();
  } else {
    globalTransactions = [];
  }

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

      home: const WelcomeScreen(), 

      routes: {
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