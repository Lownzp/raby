import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

enum RabyIconKind {
  add,
  arrowForward,
  back,
  bell,
  brokenImage,
  calendar,
  chart,
  check,
  chevronRight,
  circle,
  close,
  delete,
  diary,
  edit,
  error,
  female,
  help,
  home,
  hourglass,
  male,
  minus,
  more,
  photo,
  profile,
  rabbit,
  refresh,
  search,
  settings,
  unknown,
  weight,
}

class RabySketchIcon extends StatelessWidget {
  const RabySketchIcon({
    required this.kind,
    this.size,
    this.color,
    this.strokeWidth = 2.6,
    super.key,
  });

  final RabyIconKind kind;
  final double? size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedSize = size ?? iconTheme.size ?? 24;
    final resolvedColor =
        color ?? iconTheme.color ?? Theme.of(context).colorScheme.onSurface;

    if (kind != RabyIconKind.rabbit) {
      return Icon(_lucideIcon(kind), size: resolvedSize, color: resolvedColor);
    }

    return SizedBox.square(
      dimension: resolvedSize,
      child: CustomPaint(
        painter: _RabyRabbitIconPainter(
          color: resolvedColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

IconData _lucideIcon(RabyIconKind kind) {
  return switch (kind) {
    RabyIconKind.add => LucideIcons.plus,
    RabyIconKind.arrowForward => LucideIcons.arrowRight,
    RabyIconKind.back => LucideIcons.arrowLeft,
    RabyIconKind.bell => LucideIcons.bell,
    RabyIconKind.brokenImage => LucideIcons.imageOff,
    RabyIconKind.calendar => LucideIcons.calendarDays,
    RabyIconKind.chart => LucideIcons.chartNoAxesCombined,
    RabyIconKind.check => LucideIcons.check,
    RabyIconKind.chevronRight => LucideIcons.chevronRight,
    RabyIconKind.circle => LucideIcons.circle,
    RabyIconKind.close => LucideIcons.x,
    RabyIconKind.delete => LucideIcons.trash2,
    RabyIconKind.diary => LucideIcons.notebookPen,
    RabyIconKind.edit => LucideIcons.pencil,
    RabyIconKind.error => LucideIcons.circleAlert,
    RabyIconKind.female => LucideIcons.venus,
    RabyIconKind.help => LucideIcons.circleHelp,
    RabyIconKind.home => LucideIcons.house,
    RabyIconKind.hourglass => LucideIcons.hourglass,
    RabyIconKind.male => LucideIcons.mars,
    RabyIconKind.minus => LucideIcons.minus,
    RabyIconKind.more => LucideIcons.ellipsis,
    RabyIconKind.photo => LucideIcons.image,
    RabyIconKind.profile => LucideIcons.userRound,
    RabyIconKind.rabbit => throw StateError('Rabbit uses the brand painter.'),
    RabyIconKind.refresh => LucideIcons.refreshCw,
    RabyIconKind.search => LucideIcons.search,
    RabyIconKind.settings => LucideIcons.slidersHorizontal,
    RabyIconKind.unknown => LucideIcons.circleQuestionMark,
    RabyIconKind.weight => LucideIcons.scale,
  };
}

class _RabyRabbitIconPainter extends CustomPainter {
  const _RabyRabbitIconPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 32, size.height / 32);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final leftEar = Path()
      ..moveTo(12.2, 13.6)
      ..cubicTo(9.4, 6.7, 10.5, 3.5, 13.0, 3.7)
      ..cubicTo(15.2, 3.9, 17.0, 8.4, 16.3, 13.1);
    final rightEar = Path()
      ..moveTo(18.5, 13.1)
      ..cubicTo(18.5, 6.5, 21.4, 3.0, 23.4, 4.3)
      ..cubicTo(25.5, 5.8, 23.6, 11.4, 20.9, 15.4);
    final head = Path()
      ..moveTo(7.8, 20.0)
      ..cubicTo(7.8, 13.8, 12.5, 9.1, 18.1, 9.3)
      ..cubicTo(23.8, 9.5, 27.5, 13.8, 27.2, 19.4)
      ..cubicTo(26.9, 26.1, 22.0, 29.3, 15.4, 28.3)
      ..cubicTo(10.6, 27.7, 7.7, 24.0, 7.8, 20.0)
      ..close();
    final mouth = Path()
      ..moveTo(16.1, 24.0)
      ..cubicTo(17.1, 24.8, 19.0, 24.8, 20.2, 23.8);

    canvas
      ..drawPath(leftEar, stroke)
      ..drawPath(rightEar, stroke)
      ..drawPath(head, stroke)
      ..drawCircle(const Offset(13.8, 20.4), 1.1, fill)
      ..drawCircle(const Offset(21.1, 20.4), 1.1, fill)
      ..drawPath(mouth, stroke)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _RabyRabbitIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
