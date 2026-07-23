import 'package:flutter/material.dart';

import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_tokens.dart';
import 'raby_sketch_icon.dart';

class RabyPage extends StatelessWidget {
  const RabyPage({
    required this.title,
    required this.children,
    this.trailing,
    this.leading,
    this.centerTitle = false,
    this.bottomPadding = 148,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final Widget? leading;
  final bool centerTitle;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              RabySpacing.md,
              RabySpacing.sm,
              RabySpacing.md,
              bottomPadding,
            ),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: RabySpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        textAlign: centerTitle ? TextAlign.center : null,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (centerTitle && trailing == null)
                      const SizedBox(width: 52 + RabySpacing.sm),
                    ?trailing,
                  ],
                ),
                const SizedBox(height: RabySpacing.lg),
                ...children,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RabyIconBubble extends StatelessWidget {
  const RabyIconBubble({
    required this.icon,
    this.onTap,
    this.tooltip,
    this.size = 54,
    this.iconSize = 24,
    this.color = RabyColors.surface,
    this.iconColor = RabyColors.textPrimary,
    super.key,
  });

  final RabyIconKind icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final bubble = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(RabyRadius.xl),
        boxShadow: RabyShadows.card,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: RabySketchIcon(kind: icon, size: iconSize, color: iconColor),
        ),
      ),
    );

    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RabyRadius.xl),
        child: bubble,
      ),
    );

    if (tooltip == null) {
      return child;
    }
    return Tooltip(message: tooltip!, child: child);
  }
}

class RabyTopBar extends StatelessWidget {
  const RabyTopBar({
    required this.title,
    required this.onBack,
    this.actionIcon,
    this.actionTooltip,
    this.onAction,
    this.enabled = true,
    super.key,
  });

  final String title;
  final VoidCallback onBack;
  final RabyIconKind? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    const actionSize = 44.0;
    return SizedBox(
      height: actionSize,
      child: Row(
        children: [
          RabyIconBubble(
            key: const ValueKey('raby-top-bar-back-button'),
            icon: RabyIconKind.back,
            tooltip: '返回',
            size: actionSize,
            iconSize: 21,
            onTap: enabled ? onBack : null,
          ),
          const SizedBox(width: RabySpacing.sm),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: RabySpacing.sm),
          if (actionIcon == null)
            const SizedBox.square(dimension: actionSize)
          else
            RabyIconBubble(
              key: const ValueKey('raby-top-bar-action-button'),
              icon: actionIcon!,
              tooltip: actionTooltip,
              size: actionSize,
              iconSize: 21,
              iconColor: enabled && onAction != null
                  ? RabyColors.textPrimary
                  : RabyColors.textTertiary,
              onTap: enabled ? onAction : null,
            ),
        ],
      ),
    );
  }
}

class RabySticker extends StatelessWidget {
  const RabySticker({
    required this.icon,
    this.size = 48,
    this.rotation = 0,
    this.background = RabyColors.surfaceWarm,
    this.foreground = RabyColors.primaryDeep,
    super.key,
  });

  final RabyIconKind icon;
  final double size;
  final double rotation;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final sticker = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: RabyColors.stickerBorder, width: 4),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: RabySketchIcon(
            kind: icon,
            size: size * 0.52,
            color: foreground,
          ),
        ),
      ),
    );

    return Transform.rotate(angle: rotation, child: sticker);
  }
}

class RabyMutedText extends StatelessWidget {
  const RabyMutedText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: RabyColors.textSecondary),
    );
  }
}
