class Invitation {
  final int id;
  final String state;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int userId;
  final int sender;
  final int colocationId;

  Invitation({
    required this.id,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.sender,
    required this.colocationId,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['ID'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      deletedAt: json['DeletedAt'],
      state: json['State'],
      userId: json['UserID'],
      sender: json['Sender'],
      colocationId: json['ColocationID'],
    );
  }
}
