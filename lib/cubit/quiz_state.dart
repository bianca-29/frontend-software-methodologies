part of 'quiz_cubit.dart';


abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<dynamic> quizzes;

  const QuizLoaded(this.quizzes);
  @override
  List<Object?> get props => [quizzes];
}

class QuizSubmitting extends QuizState {}

class QuizResultReady extends QuizState {
  final dynamic result;

  const QuizResultReady(this.result);
  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
  @override
  List<Object?> get props => [message];
}