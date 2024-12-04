import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/lib/screens/quiz_app/blocs/quiz_bloc/quiz_event.dart';
import 'package:soft_for/lib/screens/quiz_app/blocs/quiz_bloc/quiz_state.dart';
import 'package:soft_for/lib/screens/quiz_app/models/question.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<LoadQuizEvent>(_onLoadQuiz);
    on<AnswerSelectedEvent>(_onAnswerSelected);
  }

  Future<void> _onLoadQuiz(LoadQuizEvent event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final questions = await _fetchQuestions();
      emit(QuizLoaded(questions: questions, currentQuestionIndex: 0, score: 0));
    } catch (e) {
      emit(QuizError(message: e.toString()));
    }
  }

  void _onAnswerSelected(AnswerSelectedEvent event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      int updatedScore = currentState.score;
      if (event.selectedAnswer ==
          currentState
              .questions[currentState.currentQuestionIndex].correctAnswer) {
        updatedScore++;
      }

      int nextQuestionIndex = currentState.currentQuestionIndex + 1;

      if (nextQuestionIndex < currentState.questions.length) {
        emit(QuizLoaded(
            questions: currentState.questions,
            currentQuestionIndex: nextQuestionIndex,
            score: updatedScore));
      } else {
        emit(QuizFinished(
            score: updatedScore,
            totalQuestions: currentState.questions.length));
      }
    }
  }

  Future<List<Question>> _fetchQuestions() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=22&difficulty=easy'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Question> questions = [];

      for (var item in data['results']) {
        questions.add(Question.fromJson(item));
      }

      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
