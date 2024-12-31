class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  int? selectedAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.selectedAnswer,
  });
}