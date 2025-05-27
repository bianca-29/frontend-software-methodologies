import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  Future<void> fetchQuizzes() async {
    emit(QuizLoading());
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/quizzes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        emit(QuizLoaded(data));
      } else {
        emit(QuizError("Failed to load quizzes"));
      }
    } catch (e) {
      emit(QuizError("Network error: $e"));
    }
  }

  Future<void> submitAnswers(String quizId, Map<String, String> answers) async {
    emit(QuizSubmitting());
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/quizzes/$quizId/submit'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        emit(QuizResultReady(result));
      } else {
        emit(QuizError("Failed to submit answers"));
      }
    } catch (e) {
      emit(QuizError("Submission failed: $e"));
    }
  }

  void reset() {
    emit(QuizInitial());
  }
}