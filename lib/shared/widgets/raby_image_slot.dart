import 'package:flutter/material.dart';

import '../../app/theme/raby_colors.dart';
import '../../app/theme/raby_tokens.dart';

class RabyImageSlot extends StatelessWidget {
  const RabyImageSlot({
    this.image,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.radius = RabyRadius.md,
    this.placeholderColor = RabyColors.surfaceSoft,
    this.semanticLabel = '待替换图片',
    super.key,
  });

  final ImageProvider? image;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit fit;
  final double radius;
  final Color placeholderColor;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget content = image == null
        ? ColoredBox(color: placeholderColor)
        : Image(
            image: image!,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, _, _) => ColoredBox(color: placeholderColor),
          );

    if (aspectRatio != null) {
      content = AspectRatio(aspectRatio: aspectRatio!, child: content);
    }

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(width: width, height: height, child: content),
      ),
    );
  }
}
