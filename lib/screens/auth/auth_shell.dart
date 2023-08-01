import 'package:flutter/material.dart';
import 'package:touriso/utils/dimensions.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: (kScreenWidth(context)) * 1.5,
          ),
          child
        ],
      ),
    );
  }
}
