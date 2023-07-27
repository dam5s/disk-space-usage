import 'package:flutter/material.dart';

class SquareTextButton extends StatelessWidget {
  final double padding;
  final void Function() onPressed;
  final Widget child;

  const SquareTextButton({super.key, this.padding = 0, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) => TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const LinearBorder()),
          padding: MaterialStateProperty.all(EdgeInsets.all(padding)),
        ),
        onPressed: onPressed,
        child: child,
      );
}

class SingleLineText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SingleLineText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) =>
    Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
}
