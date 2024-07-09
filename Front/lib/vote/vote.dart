
class Vote {
  final int id;
  final int userId;
  final int taskId;
  final int value;

Vote({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.value,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['ID'],
      userId: json['UserID'],
      taskId: json['TaskID'],
      value: json['Value'],
    );
  }
}