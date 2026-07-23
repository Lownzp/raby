import 'package:flutter/material.dart';

import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_tokens.dart';

class RabyCard extends StatelessWidget {
  const RabyCard({
    required this.child,
    this.padding = const EdgeInsets.all(RabySpacing.md),
    this.color = RabyColors.surface,
    this.borderColor = RabyColors.stickerBorder,
    this.borderWidth = 2,
    this.radius = RabyRadius.lg,
    this.softShadow = false,
    this.clayShadow = false,
    this.sketchShadow = false,
    this.gradient,
    this.boxShadow = const [],
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double radius;
  final bool softShadow;
  final bool clayShadow;
  final bool sketchShadow;
  final Gradient? gradient;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
