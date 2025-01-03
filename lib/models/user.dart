class User {
  final String id;
  final String name;
  int level;
  int score;
  List<int> completedLevels;
  List<String> completedQuizzes;

  User({
    required this.id,
    required this.name,
    this.level = 1,
    this.score = 0,
    List<int>? completedLevels,
    List<String>? completedQuizzes,
  })  : completedLevels = completedLevels ?? [],
        completedQuizzes = completedQuizzes ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'score': score,
        'completedLevels': completedLevels,
        'completedQuizzes': completedQuizzes,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        level: json['level'],
        score: json['score'],
        completedLevels: List<int>.from(json['completedLevels']),
        completedQuizzes: List<String>.from(json['completedQuizzes']),
      );
}