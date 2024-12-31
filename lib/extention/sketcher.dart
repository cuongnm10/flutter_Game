import 'package:flutter/material.dart';
import 'line.dart';

class Sketcher extends CustomPainter {
  final List<Line> lines;

  Sketcher(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (final line in lines) {
      if (line.endPoint != null) {
        canvas.drawLine(line.startPoint, line.endPoint!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.lines != lines;
  }
}

class SketcherRealtime extends CustomPainter {
  final List<Offset> points;

  SketcherRealtime(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    if (points.length >= 2) {
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SketcherRealtime oldDelegate) {
    return oldDelegate.points != points;
  }
}