import 'package:flutter/material.dart';
import 'package:touriso/screens/shared/page_layout.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'More',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text('johndoe@email.test'),
                  ],
                ),
                const SizedBox(width: 10),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_outlined),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
