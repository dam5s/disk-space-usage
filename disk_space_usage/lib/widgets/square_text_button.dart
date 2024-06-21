import 'package:flutter/material.dart';

class SquareTextButton extends StatelessWidget {
  final double padding;
  final void Function() onPressed;
  final Widget child;

  const SquareTextButton({
    super.key,
    this.padding = 0,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(const LinearBorder()),
          padding: WidgetStateProperty.all(EdgeInsets.all(padding)),
        ),
        onPressed: onPressed,
        child: child,
      );
}
