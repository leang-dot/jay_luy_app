import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final appState = AppState();
  await appState.loadInitialData();

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const JayLuyApp(),
    ),
  );
}

class JayLuyApp extends StatelessWidget {
  const JayLuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    final isWelcome = user == null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jay Luy',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: isWelcome ? const WelcomeScreen() : const MainScreen(),
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