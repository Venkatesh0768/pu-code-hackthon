class SignMessage {
  final String id;
  final String text;
  final String signVideoUrl;
  final DateTime timestamp;

  SignMessage({
    required this.id,
    required this.text,
    required this.signVideoUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'signVideoUrl': signVideoUrl,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SignMessage.fromJson(Map<String, dynamic> json) => SignMessage(
        id: json['id'],
        text: json['text'],
        signVideoUrl: json['signVideoUrl'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}