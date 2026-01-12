import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'data/local_storage.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? currentUser = await LocalStorage.loadUser();
  runApp(JayLuyApp(initialUser: currentUser));
}

class JayLuyApp extends StatelessWidget {
  final User? initialUser;
  const JayLuyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jay Luy',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Poppins'),
      home: initialUser == null
          ? const WelcomeScreen()
          : MainScreen(currentUser: initialUser!),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
