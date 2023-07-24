import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touriso/screens/auth/auth_screen.dart';

class Src extends StatelessWidget {
  const Src({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color(0xFF293B8A),
        textTheme: GoogleFonts.robotoTextTheme()
      ),
      home: const AuthScreen(authType: AuthType.signUp),
    );
  }
}
