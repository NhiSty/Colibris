class Message {
  final int id;
  final String content;
  final int senderId;
  final String colocationId;
  final String senderName;
  final String senderRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.colocationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['ID'],
      content: json['content'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderRole: json['sender_role'],
      colocationId: json['colocation_id'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'colocation_id': colocationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
