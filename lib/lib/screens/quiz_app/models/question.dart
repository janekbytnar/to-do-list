// lib/models/question.dart
import 'package:html_unescape/html_unescape.dart';

class Question {
  final String question;
  final List<String> answers;
  final String correctAnswer;
  final String type;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var unescape = HtmlUnescape();
    String questionText = unescape.convert(json['question']);
    String correctAns = unescape.convert(json['correct_answer']);
    List<String> incorrectAns = (json['incorrect_answers'] as List)
        .map((ans) => unescape.convert(ans))
        .toList();

    List<String> allAnswers = [...incorrectAns, correctAns];
    allAnswers.shuffle();

    return Question(
      question: questionText,
      answers: allAnswers,
      correctAnswer: correctAns,
      type: json['type'],
    );
  }
}
