import 'package:flutter/material.dart';
import 'package:touriso/screens/shared/page_layout.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return PageLayout(
      title: 'History',
      body: Center(child: Text('this is the history page')),
    );
  }
}
