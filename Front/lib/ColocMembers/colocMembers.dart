class ColocMembers {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int userId;
  final int colocationId;
  final int score;

  ColocMembers({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.colocationId,
    required this.score,
  });

  factory ColocMembers.fromJson(Map<String, dynamic> json) {
    return ColocMembers(
      id: json['ID'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      deletedAt: json['DeletedAt'],
      userId: json['UserID'],
      colocationId: json['ColocationID'],
      score: json['Score'],
    );
  }
}
