import 'package:flutter/material.dart';
import 'package:touriso/screens/shared/page_layout.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Pending',
      body: Center(child: Text('this is the pending page')),
    );
  }
}
