// quiz_screen.dart
import 'package:flutter/material.dart';
import 'question.dart';

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({super.key});

  @override
  State<MultipleChoice> createState()  => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  int currentQuestionIndex = 0;
  List<Question> questions = [
    Question(
      questionText: "Flutter được phát triển bởi công ty nào?",
      options: ["Google", "Facebook", "Apple", "Microsoft"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "Dart là ngôn ngữ lập trình kiểu gì?",
      options: ["Compiled", "Interpreted", "Hybrid", "None of these"],
      correctAnswerIndex: 2,
    ),
    Question(
      questionText: "Flutter's programming language?",
      options: ["python", "dart", "swift", "java"],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "backend python framework?",
      options: ["flask", "fast api", "django", "all"],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: "What is Redo shortcut in computer?",
      options: ["ctl+y", "ctl+z", "ctl+s", "ctl+p"],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "What is Undo shortcut in computer?",
      options: ["ctl+y", "ctl+z", "ctl+s", "ctl+p"],
      correctAnswerIndex: 1,
    ),
    // Thêm câu hỏi ở đây
  ];

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void selectAnswer(int selectedIndex) {
    setState(() {
      questions[currentQuestionIndex].selectedAnswer = selectedIndex;
    });
  }

  void submitQuiz() {
    int score = 0;
    for (var question in questions) {
      if (question.selectedAnswer == question.correctAnswerIndex) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kết quả'),
        content: Text('Bạn đạt được $score/${questions.length} điểm'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                currentQuestionIndex = 0;
                for (var question in questions) {
                  question.selectedAnswer = null;
                }
              });
            },
            child: Text('Làm lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = questions[currentQuestionIndex];
    bool isLastQuestion = currentQuestionIndex == questions.length - 1;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Câu hỏi ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion.questionText,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ...List.generate(
              currentQuestion.options.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                      side: BorderSide(
                      color: currentQuestion.selectedAnswer == index
                          ? Colors.cyan
                          :Colors.transparent,
                      width: 3,
                    )
                  ),
                  onPressed: () => selectAnswer(index),
                  child: Text(currentQuestion.options[index]),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentQuestionIndex > 0 ? previousQuestion : null,
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? nextQuestion
                      : submitQuiz,
                  child: isLastQuestion ? Text('Submit') : Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
