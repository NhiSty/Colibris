class Task {
  final int id;
  final String title;
  final String description;
  final String date;
  final int duration;
  final String picture;
  final int colocationId;
  final int userId;
  final int pts;
  final bool validate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.picture,
    required this.colocationId,
    required this.userId,
    required this.pts,
    required this.validate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['ID'],
      title: json['Title'],
      description: json['Description'],
      date: json['Date'],
      duration: json['Duration'],
      picture: json['Picture'],
      colocationId: json['ColocationID'],
      userId: json['UserID'],
      pts: json['Pts'],
      validate: json['Validate'],
    );
  }
}
