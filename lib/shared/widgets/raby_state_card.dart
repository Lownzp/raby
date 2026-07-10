import 'package:flutter/material.dart';

import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_tokens.dart';
import 'raby_card.dart';
import 'raby_page.dart';
import 'raby_sketch_icon.dart';

enum RabyStateTone { neutral, warm, danger }

class RabyStateCard extends StatelessWidget {
  const RabyStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.tone = RabyStateTone.neutral,
    this.fullWidthAction = true,
    super.key,
  });

  final RabyIconKind icon;
  final String title;
  final String message;
  final String? actionLabel;
  final RabyIconKind? actionIcon;
  final VoidCallback? onAction;
  final RabyStateTone tone;
  final bool fullWidthAction;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(tone);
    final actionLabel = this.actionLabel;

    Widget? action;
    if (actionLabel != null && onAction != null) {
      action = FilledButton.icon(
        onPressed: onAction,
        icon: RabySketchIcon(kind: actionIcon ?? RabyIconKind.arrowForward),
        label: Text(actionLabel),
      );
      if (fullWidthAction) {
        action = SizedBox(width: double.infinity, child: action);
      }
    }

    return RabyCard(
      color: palette.background,
      borderColor: palette.border,
      clayShadow: tone == RabyStateTone.warm,
      softShadow: tone != RabyStateTone.warm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: RabyColors.surface,
              borderRadius: BorderRadius.circular(RabyRadius.md),
              border: Border.all(color: palette.iconBorder, width: 2),
            ),
            child: SizedBox.square(
              dimension: 48,
              child: Center(
                child: RabySketchIcon(
                  kind: icon,
                  color: palette.icon,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: RabySpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: RabySpacing.xs),
          RabyMutedText(message),
          if (action != null) ...[
            const SizedBox(height: RabySpacing.md),
            action,
          ],
        ],
      ),
    );
  }
}

_StatePalette _palette(RabyStateTone tone) {
  return switch (tone) {
    RabyStateTone.neutral => const _StatePalette(
      background: RabyColors.surface,
      border: RabyColors.border,
      icon: RabyColors.primary,
      iconBorder: RabyColors.textPrimary,
    ),
    RabyStateTone.warm => const _StatePalette(
      background: RabyColors.paper,
      border: RabyColors.borderWarm,
      icon: RabyColors.primary,
      iconBorder: RabyColors.textPrimary,
    ),
    RabyStateTone.danger => const _StatePalette(
      background: RabyColors.surface,
      border: RabyColors.danger,
      icon: RabyColors.danger,
      iconBorder: RabyColors.danger,
    ),
  };
}

class _StatePalette {
  const _StatePalette({
    required this.background,
    required this.border,
    required this.icon,
    required this.iconBorder,
  });

  final Color background;
  final Color border;
  final Color icon;
  final Color iconBorder;
}
