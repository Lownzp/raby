import 'package:flutter/material.dart';

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

    return SizedBox.square(
      dimension: resolvedSize,
      child: CustomPaint(
        painter: _RabySketchIconPainter(
          kind: kind,
          color: resolvedColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _RabySketchIconPainter extends CustomPainter {
  const _RabySketchIconPainter({
    required this.kind,
    required this.color,
    required this.strokeWidth,
  });

  final RabyIconKind kind;
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

    switch (kind) {
      case RabyIconKind.add:
        _paintAdd(canvas, stroke);
      case RabyIconKind.arrowForward:
        _paintArrowForward(canvas, stroke);
      case RabyIconKind.back:
        _paintBack(canvas, stroke);
      case RabyIconKind.bell:
        _paintBell(canvas, stroke, fill);
      case RabyIconKind.brokenImage:
        _paintBrokenImage(canvas, stroke);
      case RabyIconKind.calendar:
        _paintCalendar(canvas, stroke);
      case RabyIconKind.chart:
        _paintChart(canvas, stroke);
      case RabyIconKind.check:
        _paintCheck(canvas, stroke);
      case RabyIconKind.chevronRight:
        _paintChevronRight(canvas, stroke);
      case RabyIconKind.circle:
        _paintCircle(canvas, stroke);
      case RabyIconKind.close:
        _paintClose(canvas, stroke);
      case RabyIconKind.delete:
        _paintDelete(canvas, stroke);
      case RabyIconKind.diary:
        _paintDiary(canvas, stroke);
      case RabyIconKind.edit:
        _paintEdit(canvas, stroke);
      case RabyIconKind.error:
        _paintError(canvas, stroke, fill);
      case RabyIconKind.female:
        _paintFemale(canvas, stroke);
      case RabyIconKind.help:
        _paintHelp(canvas, stroke, fill);
      case RabyIconKind.home:
        _paintHome(canvas, stroke);
      case RabyIconKind.hourglass:
        _paintHourglass(canvas, stroke);
      case RabyIconKind.male:
        _paintMale(canvas, stroke);
      case RabyIconKind.minus:
        _paintMinus(canvas, stroke);
      case RabyIconKind.more:
        _paintMore(canvas, fill);
      case RabyIconKind.photo:
        _paintPhoto(canvas, stroke);
      case RabyIconKind.profile:
        _paintProfile(canvas, stroke);
      case RabyIconKind.rabbit:
        _paintRabbit(canvas, stroke, fill);
      case RabyIconKind.refresh:
        _paintRefresh(canvas, stroke);
      case RabyIconKind.search:
        _paintSearch(canvas, stroke);
      case RabyIconKind.settings:
        _paintSettings(canvas, stroke);
      case RabyIconKind.unknown:
        _paintUnknown(canvas, stroke, fill);
      case RabyIconKind.weight:
        _paintWeight(canvas, stroke);
    }

    canvas.restore();
  }

  void _paintAdd(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(16, 8), const Offset(15.7, 24), stroke)
      ..drawLine(const Offset(8, 16.2), const Offset(24, 15.7), stroke);
  }

  void _paintMinus(Canvas canvas, Paint stroke) {
    canvas.drawLine(const Offset(8.5, 16.2), const Offset(23.5, 15.8), stroke);
  }

  void _paintArrowForward(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(8, 16), const Offset(23, 16), stroke)
      ..drawLine(const Offset(18, 10), const Offset(24, 16), stroke)
      ..drawLine(const Offset(18, 22), const Offset(24, 16), stroke);
  }

  void _paintBack(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(23, 16), const Offset(8, 16), stroke)
      ..drawLine(const Offset(13, 10), const Offset(7, 16), stroke)
      ..drawLine(const Offset(13, 22), const Offset(7, 16), stroke);
  }

  void _paintBell(Canvas canvas, Paint stroke, Paint fill) {
    final body = Path()
      ..moveTo(11.2, 14.2)
      ..cubicTo(11.0, 9.7, 13.1, 7.2, 16.1, 7.0)
      ..cubicTo(19.7, 6.8, 21.7, 9.8, 21.6, 14.2)
      ..lineTo(22.0, 20.0)
      ..lineTo(24.5, 23.0)
      ..lineTo(8.1, 23.2)
      ..lineTo(10.8, 20.0)
      ..cubicTo(10.9, 18.3, 11.0, 16.2, 11.2, 14.2);
    canvas.drawPath(body, stroke);
    canvas
      ..drawCircle(const Offset(16.0, 26.0), 1.8, fill)
      ..drawLine(const Offset(15.8, 4.5), const Offset(16.2, 6.8), stroke);
  }

  void _paintBrokenImage(Canvas canvas, Paint stroke) {
    final frame = Path()
      ..moveTo(7.2, 8.3)
      ..cubicTo(8.0, 6.9, 10.0, 6.7, 12.0, 7.0)
      ..lineTo(23.5, 7.7)
      ..cubicTo(25.6, 7.9, 26.4, 9.2, 26.1, 11.3)
      ..lineTo(25.0, 24.0)
      ..cubicTo(24.8, 25.8, 23.2, 26.5, 21.5, 26.2)
      ..lineTo(8.5, 25.5)
      ..cubicTo(6.7, 25.3, 5.7, 23.8, 6.0, 22.0)
      ..lineTo(7.0, 10.7)
      ..cubicTo(7.0, 9.7, 7.0, 8.9, 7.2, 8.3)
      ..close();
    canvas.drawPath(frame, stroke);
    canvas
      ..drawLine(const Offset(10, 21), const Offset(14, 16), stroke)
      ..drawLine(const Offset(14, 16), const Offset(17, 19.4), stroke)
      ..drawLine(const Offset(17, 19.4), const Offset(22.6, 13.2), stroke)
      ..drawLine(const Offset(16.1, 8.2), const Offset(13.4, 13.0), stroke)
      ..drawLine(const Offset(13.4, 13.0), const Offset(17.2, 15.4), stroke);
  }

  void _paintCalendar(Canvas canvas, Paint stroke) {
    final frame = Path()
      ..moveTo(8.0, 10.0)
      ..cubicTo(9.0, 8.5, 11.2, 8.4, 13.4, 8.6)
      ..lineTo(23.0, 9.1)
      ..cubicTo(25.0, 9.2, 26.1, 10.6, 25.9, 12.7)
      ..lineTo(25.0, 24.0)
      ..cubicTo(24.8, 26.0, 23.1, 26.8, 21.2, 26.6)
      ..lineTo(8.8, 25.9)
      ..cubicTo(7.0, 25.8, 6.0, 24.4, 6.3, 22.4)
      ..lineTo(7.1, 12.4)
      ..cubicTo(7.2, 11.4, 7.5, 10.6, 8.0, 10.0)
      ..close();
    canvas.drawPath(frame, stroke);
    canvas
      ..drawLine(const Offset(7.4, 15.0), const Offset(25.4, 15.0), stroke)
      ..drawLine(const Offset(11.5, 5.6), const Offset(11.4, 10.9), stroke)
      ..drawLine(const Offset(20.8, 5.9), const Offset(20.6, 11.1), stroke)
      ..drawLine(const Offset(11.2, 19.0), const Offset(13.0, 19.0), stroke)
      ..drawLine(const Offset(17.0, 19.1), const Offset(19.0, 19.1), stroke)
      ..drawLine(const Offset(11.0, 22.4), const Offset(13.2, 22.4), stroke);
  }

  void _paintChart(Canvas canvas, Paint stroke) {
    final path = Path()
      ..moveTo(6.5, 22.5)
      ..lineTo(12.2, 17.0)
      ..lineTo(16.2, 19.8)
      ..lineTo(24.8, 10.0);
    canvas.drawPath(path, stroke);
    canvas
      ..drawCircle(const Offset(12.2, 17.0), 1.5, stroke)
      ..drawCircle(const Offset(24.8, 10.0), 1.5, stroke);
  }

  void _paintCheck(Canvas canvas, Paint stroke) {
    final path = Path()
      ..moveTo(8.0, 16.5)
      ..lineTo(13.2, 22.0)
      ..lineTo(24.8, 9.8);
    canvas.drawPath(path, stroke);
  }

  void _paintChevronRight(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(12, 8), const Offset(21, 16), stroke)
      ..drawLine(const Offset(21, 16), const Offset(12, 24), stroke);
  }

  void _paintCircle(Canvas canvas, Paint stroke) {
    final circle = Path()
      ..moveTo(16.0, 5.4)
      ..cubicTo(22.1, 5.3, 26.6, 9.8, 26.4, 16.0)
      ..cubicTo(26.2, 22.0, 21.6, 26.6, 15.8, 26.5)
      ..cubicTo(9.8, 26.4, 5.4, 21.7, 5.7, 15.6)
      ..cubicTo(5.9, 9.8, 10.0, 5.6, 16.0, 5.4)
      ..close();
    canvas.drawPath(circle, stroke);
  }

  void _paintClose(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(9, 9), const Offset(23, 23), stroke)
      ..drawLine(const Offset(23, 9), const Offset(9, 23), stroke);
  }

  void _paintDelete(Canvas canvas, Paint stroke) {
    final bin = Path()
      ..moveTo(10.0, 12.0)
      ..lineTo(11.2, 25.0)
      ..cubicTo(11.4, 26.3, 12.6, 27.0, 14.0, 26.8)
      ..lineTo(21.4, 26.3)
      ..cubicTo(22.7, 26.1, 23.5, 25.2, 23.6, 23.8)
      ..lineTo(24.0, 12.3);
    canvas
      ..drawPath(bin, stroke)
      ..drawLine(const Offset(8.0, 10.0), const Offset(25.8, 10.0), stroke)
      ..drawLine(const Offset(13.0, 7.0), const Offset(20.5, 7.1), stroke)
      ..drawLine(const Offset(15.0, 14.4), const Offset(15.4, 22.0), stroke)
      ..drawLine(const Offset(20.0, 14.4), const Offset(19.6, 22.0), stroke);
  }

  void _paintDiary(Canvas canvas, Paint stroke) {
    final page = Path()
      ..moveTo(8.3, 6.7)
      ..cubicTo(9.2, 5.9, 11.0, 5.8, 13.0, 6.0)
      ..lineTo(21.7, 6.6)
      ..cubicTo(24.0, 6.8, 25.1, 8.3, 24.8, 10.5)
      ..lineTo(23.7, 24.0)
      ..cubicTo(23.5, 26.0, 22.0, 27.0, 19.9, 26.7)
      ..lineTo(8.8, 25.9)
      ..cubicTo(7.2, 25.7, 6.4, 24.4, 6.6, 22.5)
      ..lineTo(7.5, 9.6)
      ..cubicTo(7.6, 8.3, 7.8, 7.4, 8.3, 6.7)
      ..close();
    canvas.drawPath(page, stroke);
    canvas
      ..drawLine(const Offset(11.3, 12.0), const Offset(19.0, 12.2), stroke)
      ..drawLine(const Offset(11.1, 16.2), const Offset(17.5, 16.0), stroke);
    _paintMiniPencil(canvas, stroke);
  }

  void _paintEdit(Canvas canvas, Paint stroke) {
    _paintMiniPencil(canvas, stroke);
    canvas
      ..drawLine(const Offset(7.5, 24.8), const Offset(15.5, 24.6), stroke)
      ..drawLine(const Offset(8.5, 20.8), const Offset(10.0, 24.6), stroke);
  }

  void _paintError(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(16, 16), 11.0, stroke);
    canvas
      ..drawLine(const Offset(16, 9.8), const Offset(16.2, 17.8), stroke)
      ..drawCircle(const Offset(16.1, 22.2), 1.5, fill);
  }

  void _paintFemale(Canvas canvas, Paint stroke) {
    canvas.drawCircle(const Offset(16, 12.2), 6.0, stroke);
    canvas
      ..drawLine(const Offset(16, 18.3), const Offset(16, 26.0), stroke)
      ..drawLine(const Offset(11.5, 22.5), const Offset(20.5, 22.5), stroke);
  }

  void _paintHelp(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(16, 16), 11.0, stroke);
    final mark = Path()
      ..moveTo(12.2, 13.2)
      ..cubicTo(12.8, 10.6, 15.8, 9.5, 18.2, 10.6)
      ..cubicTo(21.3, 12.1, 20.4, 15.6, 17.4, 17.0)
      ..cubicTo(16.2, 17.6, 15.8, 18.3, 15.9, 19.5);
    canvas
      ..drawPath(mark, stroke)
      ..drawCircle(const Offset(16.0, 23.0), 1.4, fill);
  }

  void _paintHome(Canvas canvas, Paint stroke) {
    final roof = Path()
      ..moveTo(6.8, 16.0)
      ..lineTo(15.7, 7.4)
      ..lineTo(25.6, 15.7);
    final body = Path()
      ..moveTo(9.5, 15.4)
      ..lineTo(9.2, 25.0)
      ..cubicTo(10.0, 26.4, 12.0, 26.6, 14.0, 26.5)
      ..lineTo(22.4, 26.2)
      ..cubicTo(24.0, 26.0, 24.8, 24.8, 24.6, 23.0)
      ..lineTo(24.1, 15.4);
    canvas
      ..drawPath(roof, stroke)
      ..drawPath(body, stroke)
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(14.0, 18.0, 4.5, 8.2),
          const Radius.circular(2),
        ),
        stroke,
      );
  }

  void _paintHourglass(Canvas canvas, Paint stroke) {
    final glass = Path()
      ..moveTo(10, 6.5)
      ..cubicTo(12.5, 7.0, 19.6, 7.0, 22.3, 6.6)
      ..lineTo(20.5, 11.2)
      ..cubicTo(19.4, 13.5, 17.8, 15.0, 16.0, 16.0)
      ..cubicTo(18.0, 17.3, 19.8, 19.2, 21.0, 22.0)
      ..lineTo(22.4, 25.8)
      ..cubicTo(19.7, 25.4, 12.7, 25.5, 10.0, 26.0)
      ..lineTo(11.4, 22.0)
      ..cubicTo(12.7, 19.0, 14.1, 17.4, 16.0, 16.0)
      ..cubicTo(14.1, 14.7, 12.4, 12.6, 11.2, 10.2)
      ..close();
    canvas.drawPath(glass, stroke);
  }

  void _paintMale(Canvas canvas, Paint stroke) {
    canvas.drawCircle(const Offset(13.4, 18.2), 6.0, stroke);
    canvas
      ..drawLine(const Offset(17.8, 13.8), const Offset(25.5, 6.0), stroke)
      ..drawLine(const Offset(20.8, 6.0), const Offset(25.5, 6.0), stroke)
      ..drawLine(const Offset(25.5, 6.0), const Offset(25.5, 10.8), stroke);
  }

  void _paintMore(Canvas canvas, Paint fill) {
    canvas
      ..drawCircle(const Offset(9.5, 16.0), 2.2, fill)
      ..drawCircle(const Offset(16.0, 15.7), 2.2, fill)
      ..drawCircle(const Offset(22.7, 16.2), 2.2, fill);
  }

  void _paintPhoto(Canvas canvas, Paint stroke) {
    final frame = Path()
      ..moveTo(7.3, 8.8)
      ..cubicTo(8.2, 7.4, 10.2, 7.1, 12.3, 7.4)
      ..lineTo(23.6, 8.0)
      ..cubicTo(25.8, 8.2, 26.7, 9.8, 26.3, 12.0)
      ..lineTo(25.3, 23.4)
      ..cubicTo(25.1, 25.5, 23.5, 26.4, 21.4, 26.1)
      ..lineTo(8.6, 25.5)
      ..cubicTo(6.8, 25.2, 5.9, 23.8, 6.2, 21.9)
      ..lineTo(7.0, 11.0)
      ..cubicTo(7.0, 10.1, 7.1, 9.4, 7.3, 8.8)
      ..close();
    canvas.drawPath(frame, stroke);
    canvas
      ..drawCircle(const Offset(20.8, 12.5), 1.7, stroke)
      ..drawLine(const Offset(9.8, 21.0), const Offset(14.0, 16.4), stroke)
      ..drawLine(const Offset(14.0, 16.4), const Offset(17.1, 19.8), stroke)
      ..drawLine(const Offset(17.1, 19.8), const Offset(21.8, 15.4), stroke);
  }

  void _paintProfile(Canvas canvas, Paint stroke) {
    canvas.drawCircle(const Offset(16.1, 11.8), 5.2, stroke);
    final body = Path()
      ..moveTo(8.3, 26.0)
      ..cubicTo(9.2, 20.8, 13.0, 18.4, 16.3, 18.5)
      ..cubicTo(20.5, 18.7, 23.6, 21.4, 24.2, 26.0);
    canvas.drawPath(body, stroke);
  }

  void _paintRabbit(Canvas canvas, Paint stroke, Paint fill) {
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
    canvas
      ..drawPath(leftEar, stroke)
      ..drawPath(rightEar, stroke)
      ..drawPath(head, stroke)
      ..drawCircle(const Offset(13.8, 20.4), 1.1, fill)
      ..drawCircle(const Offset(21.1, 20.4), 1.1, fill);
    final mouth = Path()
      ..moveTo(16.1, 24.0)
      ..cubicTo(17.1, 24.8, 19.0, 24.8, 20.2, 23.8);
    canvas.drawPath(mouth, stroke);
  }

  void _paintRefresh(Canvas canvas, Paint stroke) {
    final arc = Path()
      ..moveTo(24.5, 12.5)
      ..cubicTo(22.6, 8.8, 18.8, 6.8, 14.8, 7.4)
      ..cubicTo(10.0, 8.1, 6.8, 12.2, 7.3, 17.0)
      ..cubicTo(7.9, 22.1, 12.3, 25.2, 17.0, 24.6)
      ..cubicTo(19.9, 24.2, 22.1, 22.8, 23.6, 20.8);
    canvas.drawPath(arc, stroke);
    canvas
      ..drawLine(const Offset(24.5, 12.5), const Offset(25.4, 7.9), stroke)
      ..drawLine(const Offset(24.5, 12.5), const Offset(20.2, 11.0), stroke);
  }

  void _paintSearch(Canvas canvas, Paint stroke) {
    final lens = Path()
      ..moveTo(14.4, 6.8)
      ..cubicTo(19.4, 6.2, 23.2, 9.5, 23.5, 14.2)
      ..cubicTo(23.8, 19.0, 20.5, 22.5, 15.8, 22.7)
      ..cubicTo(11.0, 22.9, 7.4, 19.7, 7.2, 15.0)
      ..cubicTo(7.0, 10.6, 10.0, 7.2, 14.4, 6.8)
      ..close();
    canvas
      ..drawPath(lens, stroke)
      ..drawLine(const Offset(21.4, 21.0), const Offset(26.2, 25.8), stroke);
  }

  void _paintSettings(Canvas canvas, Paint stroke) {
    canvas
      ..drawLine(const Offset(7.0, 10.0), const Offset(25.0, 9.8), stroke)
      ..drawCircle(const Offset(13.2, 9.9), 2.2, stroke)
      ..drawLine(const Offset(7.0, 16.2), const Offset(25.0, 16.4), stroke)
      ..drawCircle(const Offset(20.0, 16.3), 2.2, stroke)
      ..drawLine(const Offset(7.0, 22.4), const Offset(25.0, 22.0), stroke)
      ..drawCircle(const Offset(15.8, 22.2), 2.2, stroke);
  }

  void _paintUnknown(Canvas canvas, Paint stroke, Paint fill) {
    canvas.drawCircle(const Offset(16, 16), 11.0, stroke);
    canvas
      ..drawLine(const Offset(16, 20.2), const Offset(16, 20.4), stroke)
      ..drawCircle(const Offset(16.0, 23.0), 1.4, fill);
    final mark = Path()
      ..moveTo(12.6, 13.0)
      ..cubicTo(13.0, 10.5, 16.0, 9.7, 18.2, 10.8)
      ..cubicTo(20.7, 12.1, 20.0, 15.3, 17.3, 16.8)
      ..cubicTo(16.2, 17.4, 15.8, 18.2, 16.0, 19.5);
    canvas.drawPath(mark, stroke);
  }

  void _paintWeight(Canvas canvas, Paint stroke) {
    final body = Path()
      ..moveTo(8.3, 8.7)
      ..cubicTo(9.4, 6.2, 12.2, 5.7, 15.4, 6.0)
      ..lineTo(22.6, 6.5)
      ..cubicTo(25.4, 6.8, 26.7, 8.7, 26.4, 11.4)
      ..lineTo(25.5, 23.5)
      ..cubicTo(25.3, 26.0, 23.5, 27.3, 20.8, 27.0)
      ..lineTo(9.7, 26.5)
      ..cubicTo(7.4, 26.3, 5.9, 24.3, 6.2, 21.9)
      ..lineTo(7.1, 11.6)
      ..cubicTo(7.2, 10.5, 7.6, 9.5, 8.3, 8.7)
      ..close();
    canvas.drawPath(body, stroke);

    final gauge = Path()
      ..moveTo(11.5, 16.4)
      ..cubicTo(13.0, 12.9, 18.2, 12.1, 21.0, 15.8);
    canvas.drawPath(gauge, stroke);
    canvas
      ..drawLine(const Offset(16.2, 16.2), const Offset(19.1, 12.7), stroke)
      ..drawLine(const Offset(12.2, 22.0), const Offset(20.0, 22.3), stroke);
  }

  void _paintMiniPencil(Canvas canvas, Paint stroke) {
    final pencil = Path()
      ..moveTo(18.2, 22.8)
      ..lineTo(25.8, 15.1)
      ..lineTo(27.7, 17.0)
      ..lineTo(20.1, 24.6)
      ..lineTo(17.8, 25.1)
      ..close();
    canvas.drawPath(pencil, stroke);
    canvas.drawLine(const Offset(24.7, 16.0), const Offset(26.7, 18.0), stroke);
  }

  @override
  bool shouldRepaint(covariant _RabySketchIconPainter oldDelegate) {
    return oldDelegate.kind != kind ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
