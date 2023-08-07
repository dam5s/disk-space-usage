import 'package:flutter/widgets.dart';

class SingleLineText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SingleLineText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
}
