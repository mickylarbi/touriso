import 'package:flutter/material.dart';
import 'package:touriso/utils/colors.dart';

// ignore: must_be_immutable
class LoadingButton extends StatelessWidget {
  LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.minimumSize,
    this.shape,
  });

  final Function? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final OutlinedBorder? shape;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => FilledButton(
        onPressed: onPressed == null
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });

                await onPressed!();

                isLoading = false;
                setState(() {
                  isLoading = false;
                });
              },
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}

class MenuTextButton extends StatelessWidget {
  MenuTextButton(
      {super.key, required this.title, required this.items, this.onSelected});
  final String title;
  final List<PopupMenuEntry> items;
  final Function(dynamic)? onSelected;

  final GlobalKey<PopupMenuButtonState> menuStateKey =
      GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: menuStateKey,
      itemBuilder: (context) => items,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () {
          menuStateKey.currentState!.showButtonMenu();
        },
        child: Text(title),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton(
      {super.key, required this.icon, this.color, this.onPressed});
  final IconData icon;
  final Color? color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: (color ?? primaryColor).withOpacity(.1),
        foregroundColor: color,
        iconColor: color,
      ),
      child: const Icon(Icons.delete),
    );
  }
}

class StatefulLoadingButton extends StatelessWidget {
  const StatefulLoadingButton({
    super.key,
    required this.buttonEnabledNotifier,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.minimumSize,
    this.shape,
  });

  final ValueNotifier<bool> buttonEnabledNotifier;
  final Function? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: buttonEnabledNotifier,
      builder: (context, value, _) {
        return LoadingButton(
          onPressed: value ? onPressed : null,
          child: child,
        );
      },
    );
  }
}


class ReloadButton extends StatelessWidget {
  const ReloadButton({super.key, this.onPressed});
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh),
      label: const Text('Reload'),
    );
  }
}