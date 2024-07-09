class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  int? colocMemberId;
  int? colocationId;
  int? score;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.colocMemberId,
    this.colocationId,
    this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      email: json['Email'],
      firstname: json['Firstname'],
      lastname: json['Lastname'],
      colocMemberId: json['ColocMemberID'],
      colocationId: json['ColocationID'],
      score: json['Score'],
    );
  }
}
