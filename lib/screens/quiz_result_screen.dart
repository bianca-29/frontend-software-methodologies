import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/quiz_cubit.dart';

class QuizResultScreen extends StatelessWidget {
  final dynamic result;

  const QuizResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = result['details'] as List<dynamic>;
    final score = result['score'];
    final total = result['total'];

    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Score: $score / $total", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return ListTile(
                    title: Text(detail['questionText']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Answer: ${detail['userAnswer']}"),
                        Text("Correct Answer: ${detail['correctAnswer']}"),
                      ],
                    ),
                    trailing: Icon(
                      detail['correct']
                          ? Icons.check_circle_outline_rounded
                          : Icons.cancel_outlined,
                      color: detail['correct'] ? Colors.green : Colors.red,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                context.read<QuizCubit>().reset();
                context.read<QuizCubit>().fetchQuizzes();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back to Quizzes"),
            )
          ],
        ),
      ),
    );
  }
}