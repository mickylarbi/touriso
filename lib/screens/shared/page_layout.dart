import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  const PageLayout(
      {super.key, required this.title, this.actions, required this.body});
  final String title;
  final List<Widget>? actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              if (actions != null) ...?actions
            ],
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
