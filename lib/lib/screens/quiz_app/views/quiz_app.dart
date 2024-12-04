// lib/screens/quiz_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/lib/screens/quiz_app/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:soft_for/lib/screens/quiz_app/blocs/quiz_bloc/quiz_event.dart';
import 'package:soft_for/lib/screens/quiz_app/blocs/quiz_bloc/quiz_state.dart';
import 'package:soft_for/lib/screens/quiz_app/views/result_page.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc()..add(LoadQuizEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: Center(
          child: BlocConsumer<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state is QuizError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is QuizFinished) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      score: state.score,
                      totalQuestions: state.totalQuestions,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is QuizLoading || state is QuizInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is QuizLoaded) {
                final question = state.questions[state.currentQuestionIndex];
                print(question.correctAnswer);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Question ${state.currentQuestionIndex + 1} of ${state.questions.length}',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        question.question,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ...question.answers.map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<QuizBloc>().add(
                                  AnswerSelectedEvent(selectedAnswer: answer));
                            },
                            child: Text(answer),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              } else if (state is QuizError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
