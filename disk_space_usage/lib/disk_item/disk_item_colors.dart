import 'package:flutter/material.dart';

class DiskItemColors {
  var _currentIndex = -1;

  Color next(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _currentIndex++;

    return switch (_currentIndex % 7) {
      0 => colorScheme.background,
      1 => colorScheme.surface,
      2 => colorScheme.surfaceVariant,
      3 => colorScheme.surfaceTint,
      4 => colorScheme.secondaryContainer,
      5 => colorScheme.tertiaryContainer,
      _ => colorScheme.primaryContainer,
    }
        .withOpacity(0.25);
  }
}
