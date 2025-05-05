import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/brain_tumor_screen.dart';
import 'screens/settings_page.dart';
import 'screens/coming_soon_page.dart';
import 'screens/diagnosis_page.dart';
import 'screens/signup_page.dart';
import 'screens/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEUROPULSE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const MyHomePage(),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/brain_tumor': (context) => const BrainTumorScreen(),
        '/coming_soon': (context) => const ComingSoonPage(),
        '/settings': (context) => const SettingsPage(),
        '/diagnosis': (context) => const DiagnosisPage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
