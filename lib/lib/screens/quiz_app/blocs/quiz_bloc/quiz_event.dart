import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadQuizEvent extends QuizEvent {}

class AnswerSelectedEvent extends QuizEvent {
  final String selectedAnswer;

  AnswerSelectedEvent({required this.selectedAnswer});

  @override
  List<Object?> get props => [selectedAnswer];
}
