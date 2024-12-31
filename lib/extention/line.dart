import 'package:flutter/material.dart';
class Line {
  final GlobalKey questionKey;
  Offset startPoint;
  Offset? endPoint;
  bool isFinished;
  GlobalKey? answerKey;

  Line({
    required this.questionKey,
    required this.startPoint,
    this.endPoint,
    this.isFinished = false,
    this.answerKey,
  });
}