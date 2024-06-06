class Conversation {
  final int id;
  final String name;
  final String lastMessage;

  Conversation({required this.id, required this.name, required this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {

    return Conversation(
      id: json['ID'],
      name: json['Name'],
      lastMessage: "json['lastMessage']",
    );
  }
}
