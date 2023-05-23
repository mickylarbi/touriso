import 'package:flutter/material.dart';
import 'package:touriso/screens/auth/auth_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color(0xFF293B8A)),
      home: const AuthScreen(authType: AuthType.signUp),
    );
  }
}
