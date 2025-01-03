class Quiz {
  final String id;
  final String question;
  final String signVideoUrl;
  final List<String> options;
  final String correctAnswer;
  final int level;
  final int points;

  Quiz({
    required this.id,
    required this.question,
    required this.signVideoUrl,
    required this.options,
    required this.correctAnswer,
    required this.level,
    this.points = 10,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'signVideoUrl': signVideoUrl,
        'options': options,
        'correctAnswer': correctAnswer,
        'level': level,
        'points': points,
      };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'],
        question: json['question'],
        signVideoUrl: json['signVideoUrl'],
        options: List<String>.from(json['options']),
        correctAnswer: json['correctAnswer'],
        level: json['level'],
        points: json['points'],
      );
}
