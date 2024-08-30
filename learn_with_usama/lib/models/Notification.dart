class MyNotification {
  final String title;
  final String body;
  final DateTime date;

  MyNotification({required this.title, required this.body, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
    };
  }

  factory MyNotification.fromMap(Map<String, dynamic> map) {
    return MyNotification(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}
