import 'package:flutter/material.dart';
import 'package:soft_for/lib/screens/quiz_app/views/quiz_app.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    if (score == totalQuestions) {
      message = 'Great Job!';
    } else if (score > totalQuestions / 2) {
      message = 'Good Job!';
    } else {
      message = 'Try again!';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your result: $score/$totalQuestions',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to completed tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
