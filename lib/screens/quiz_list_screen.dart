import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/quiz_cubit.dart';
import 'package:frontend/screens/quiz_result_screen.dart';
import 'quiz_taking_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({Key? key}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<QuizCubit>();
    if (cubit.state is QuizInitial) {
      cubit.fetchQuizzes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Quizzes')),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizInitial || state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizLoaded) {
            return ListView.builder(
              itemCount: state.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = state.quizzes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(quiz['title']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizTakingScreen(
                            quizId: quiz['id'],
                            title: quiz['title'],
                            questions: quiz['questions'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is QuizError) {
            return Center(child: Text(state.message));
          } else if (state is QuizResultReady) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizResultScreen(result: state.result),
                ),
              );
            });
            return const Center(child: Text("Preparing results..."));
          }

          return const Center(child: Text("Unknown state"));
        },
      ),
    );
  }
}