import 'package:flutter/material.dart';
import 'package:touriso/utils/text_styles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.text,
    this.name,
    this.type,
  });

  final String? text;
  final String? name;
  final bool? type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.pink[900],
          child: const Text('T'),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name ?? "",
              style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text ?? ''),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              name ?? '',
              style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text ?? ''),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          child: Text(
            name?[0] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (type ?? false) ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
