import 'package:flutter/material.dart';
import 'package:touriso/screens/shared/page_layout.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Chat',
      body: Center(child: Text('this is the chat page')),
    );
  }
}
