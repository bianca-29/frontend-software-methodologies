import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/quiz_cubit.dart';

class QuizTakingScreen extends StatefulWidget {
  final String quizId;
  final String title;
  final List<dynamic> questions;

  const QuizTakingScreen({
    Key? key,
    required this.quizId,
    required this.title,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  Map<String, String> answers = {};

  void _saveAnswer(String questionId, String selectedAnswer) {
    setState(() {
      answers = {...answers, questionId: selectedAnswer};
    });
  }

  bool get allAnswered => widget.questions.length == answers.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.questions.length,
          itemBuilder: (context, index) {
            final q = widget.questions[index];
            final questionId = q['id'] ?? "q$index";
            final questionText = q['text'] ?? "Unknown question";
            final options = q['options']?.cast<String>() ?? [];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(questionText, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...options.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: answers[questionId],
                        onChanged: (value) => _saveAnswer(questionId, value!),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: allAnswered
              ? () => context.read<QuizCubit>().submitAnswers(widget.quizId, answers)
              : null,
          child: const Text("Submit"),
        ),
      ),
    );
  }
}