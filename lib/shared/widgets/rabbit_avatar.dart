import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers/repository_providers.dart';
import '../../app/theme/raby_colors.dart';

class RabbitAvatar extends ConsumerWidget {
  const RabbitAvatar({
    this.avatarPath,
    this.localPath,
    this.size = 64,
    this.iconSize = 30,
    this.borderWidth = 0,
    this.borderColor = RabyColors.border,
    super.key,
  });

  final String? avatarPath;
  final String? localPath;
  final double size;
  final double iconSize;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = localPath;
    if (local != null && local.isNotEmpty) {
      return _AvatarFrame(
        size: size,
        borderWidth: borderWidth,
        borderColor: borderColor,
        child: _AvatarImage(file: File(local), iconSize: iconSize),
      );
    }

    final relative = avatarPath;
    if (relative == null || relative.isEmpty) {
      return _AvatarFrame(
        size: size,
        borderWidth: borderWidth,
        borderColor: borderColor,
        child: _AvatarPlaceholder(iconSize: iconSize),
      );
    }

    return FutureBuilder<File>(
      future: ref.watch(mediaStorageServiceProvider).resolve(relative),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return _AvatarFrame(
          size: size,
          borderWidth: borderWidth,
          borderColor: borderColor,
          child: file == null
              ? _AvatarPlaceholder(iconSize: iconSize)
              : _AvatarImage(file: file, iconSize: iconSize),
        );
      },
    );
  }
}

class _AvatarFrame extends StatelessWidget {
  const _AvatarFrame({
    required this.size,
    required this.child,
    required this.borderWidth,
    required this.borderColor,
  });

  final double size;
  final Widget child;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWidth <= 0
            ? null
            : Border.all(color: borderColor, width: borderWidth),
      ),
      child: ClipOval(
        child: SizedBox.square(dimension: size, child: child),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({required this.file, required this.iconSize});

  final File file;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _AvatarPlaceholder(iconSize: iconSize);
      },
      errorBuilder: (context, error, stackTrace) =>
          _AvatarPlaceholder(iconSize: iconSize),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RabyColors.surfaceWarm,
      child: Center(
        child: SizedBox.square(
          dimension: iconSize * 1.45,
          child: const CustomPaint(painter: _BunnyStickerPainter()),
        ),
      ),
    );
  }
}

class _BunnyStickerPainter extends CustomPainter {
  const _BunnyStickerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 72, size.height / 72);

    final shadow = Paint()
      ..color = RabyColors.secondary.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final fur = Paint()
      ..color = RabyColors.paper
      ..style = PaintingStyle.fill;
    final earInner = Paint()
      ..color = const Color(0xFFFFD8CC)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = RabyColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final face = Paint()
      ..color = RabyColors.secondary
      ..style = PaintingStyle.fill;
    final blush = Paint()
      ..color = RabyColors.accent.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final leftEar = Path()
      ..moveTo(25, 29)
      ..cubicTo(18, 10, 21, 1, 28, 2)
      ..cubicTo(35, 3, 39, 17, 36, 32);
    final rightEar = Path()
      ..moveTo(42, 31)
      ..cubicTo(43, 13, 51, 3, 58, 7)
      ..cubicTo(64, 11, 58, 27, 48, 40);
    final head = Path()
      ..moveTo(12, 43)
      ..cubicTo(12, 26, 25, 17, 39, 19)
      ..cubicTo(54, 21, 64, 32, 62, 47)
      ..cubicTo(60, 62, 47, 69, 32, 66)
      ..cubicTo(19, 63, 12, 55, 12, 43)
      ..close();

    canvas
      ..drawPath(head.shift(const Offset(1.8, 2.6)), shadow)
      ..drawPath(leftEar, fur)
      ..drawPath(rightEar, fur)
      ..drawPath(head, fur);

    final leftInner = Path()
      ..moveTo(28, 26)
      ..cubicTo(25, 13, 27, 7, 29, 8)
      ..cubicTo(33, 9, 34, 20, 32, 29);
    final rightInner = Path()
      ..moveTo(47, 31)
      ..cubicTo(49, 18, 53, 11, 56, 13)
      ..cubicTo(58, 15, 54, 26, 49, 35);
    canvas
      ..drawPath(leftInner, earInner)
      ..drawPath(rightInner, earInner)
      ..drawPath(leftEar, stroke)
      ..drawPath(rightEar, stroke)
      ..drawPath(head, stroke)
      ..drawOval(const Rect.fromLTWH(19, 45, 10, 6), blush)
      ..drawOval(const Rect.fromLTWH(46, 45, 10, 6), blush)
      ..drawCircle(const Offset(28, 42), 2.2, face)
      ..drawCircle(const Offset(48, 42), 2.2, face)
      ..drawCircle(const Offset(38, 49), 1.6, face);

    final mouth = Path()
      ..moveTo(38, 50)
      ..cubicTo(35, 54, 32, 54, 30, 51)
      ..moveTo(38, 50)
      ..cubicTo(41, 54, 45, 54, 47, 51);
    canvas.drawPath(mouth, stroke..strokeWidth = 2.2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BunnyStickerPainter oldDelegate) => false;
}
