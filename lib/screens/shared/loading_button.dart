import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadingButton extends StatelessWidget {
  LoadingButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.backgroundColor,
      this.foregroundColor,
      this.minimumSize,
      this.shape});
  final Function onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final OutlinedBorder? shape;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => ElevatedButton(
        onPressed: () async {
          isLoading = true;
          setState(() {});

          await onPressed();

          isLoading = false;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          minimumSize: minimumSize ?? const Size.fromHeight(48),
          // backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          // foregroundColor: foregroundColor,
          // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}
