import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final List<Map<String, String>> originalQuestions = [
    {'question': 'bee.png', 'answer': 'Bee'},
    {'question': 'bird.png', 'answer': 'Bird'},
    {'question': 'panda.png', 'answer': 'Panda'},
    {'question': 'pumpkin.png', 'answer': 'Pumpkin'},
  ];

  late List<Map<String, String>> questions;

  @override
  void initState() {
    super.initState();
    questions = List.from(originalQuestions)..shuffle();
  }

  bool isCorrectPosition(int index) {
    return questions[index]['answer'] == originalQuestions[index]['answer'];
  }

  bool checkWin() {
    for (int i = 0; i < questions.length; i++) {
      if (!isCorrectPosition(i)) return false;
    }
    return true;
  }

  // Custom card widget với gesture detection
  Widget buildDraggableCard(BuildContext context, int index) {
    return Card(
      key: ValueKey(questions[index]),
      elevation: 3.0,
      color: isCorrectPosition(index) ? Colors.green.shade100 : Colors.blue.shade100,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // Đảm bảo gesture được nhận diện trên toàn bộ card
        onTapDown: (_) {
          // Thêm feedback haptic khi chạm vào card
          HapticFeedback.lightImpact();
        },
        child: Stack(
          children: [

            ListTile(
              title: Image.asset('assets/images/${questions[index]['question']}',width: 80,height: 76,)
            ),
            Positioned.fill(
              child: Row(
                children: [
                  // Vùng kéo thả bên trái
                  ReorderableDragStartListener(
                    index: index,
                    child: Container(

                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.drag_indicator, color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    // Vùng kéo thả ở giữa
                    child: ReorderableDragStartListener(
                      index: index,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Vùng kéo thả bên phải
                  ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.drag_indicator, color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]
    );
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ScrollConfiguration(
              // Tùy chỉnh behavior của scroll
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ReorderableListView.builder(
                physics: const ClampingScrollPhysics(),
                buildDefaultDragHandles: false,
                padding: const EdgeInsets.all(8),
                itemCount: questions.length,
                proxyDecorator: (child, index, animation) {
                  // Tùy chỉnh hiệu ứng khi đang kéo
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      final double scale = lerpDouble(1, 1.05, animation.value)!;
                      return Transform.scale(
                        scale: scale,
                        child: Material(
                          elevation: 8,
                          color: Colors.transparent,
                          child: child,
                        ),
                      );
                    },
                    child: child,
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = questions.removeAt(oldIndex);
                    questions.insert(newIndex, item);

                    // Thêm feedback haptic khi hoán đổi vị trí
                    HapticFeedback.mediumImpact();

                    if (checkWin()) {
                      // Thêm feedback haptic khi thắng
                      HapticFeedback.heavyImpact();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Chúc mừng!'),
                          content: const Text('Bạn đã sắp xếp đúng tất cả các câu!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  });
                },
                itemBuilder: (context, index) => buildDraggableCard(context, index),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: originalQuestions.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.orange.shade100,
                    child: ListTile(
                      title: Text(originalQuestions[index]['answer']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            questions = List.from(originalQuestions)..shuffle();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}