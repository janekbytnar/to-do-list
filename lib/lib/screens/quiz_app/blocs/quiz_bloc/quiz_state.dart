import 'package:equatable/equatable.dart';
import 'package:soft_for/lib/screens/quiz_app/models/question.dart';

// Stany
abstract class QuizState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;

  QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
  });

  @override
  List<Object?> get props => [questions, currentQuestionIndex, score];
}

class QuizError extends QuizState {
  final String message;

  QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}

class QuizFinished extends QuizState {
  final int score;
  final int totalQuestions;

  QuizFinished({required this.score, required this.totalQuestions});

  @override
  List<Object?> get props => [score, totalQuestions];
}
