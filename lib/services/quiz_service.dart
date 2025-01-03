import 'package:sign_learn/models/quiz.dart';

class QuizService {
  final List<Quiz> _quizzes = [
    Quiz(
      id: '1',
      question: 'What does this sign mean?',
      signVideoUrl: 'assets/videos/hello.mp4',
      options: ['Hello', 'Goodbye', 'Thank you', 'Please'],
      correctAnswer: 'Hello',
      level: 1,
    ),
    // Add more quizzes
  ];

  List<Quiz> getQuizzesForLevel(int level) {
    return _quizzes.where((quiz) => quiz.level == level).toList();
  }

  bool checkAnswer(String quizId, String answer) {
    final quiz = _quizzes.firstWhere((q) => q.id == quizId);
    return quiz.correctAnswer == answer;
  }
}