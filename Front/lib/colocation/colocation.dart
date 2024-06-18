class Colocation {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String name;
  final int userId;
  final dynamic colocMembers;
  final String? description;
  final bool isPermanent;
  final String location;
  final double latitude;
  final double longitude;

  Colocation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.userId,
    this.colocMembers,
    this.description,
    required this.isPermanent,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory Colocation.fromJson(Map<String, dynamic> json) {
    return Colocation(
      id: json['ID'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      deletedAt: json['DeletedAt'],
      name: json['Name'],
      userId: json['UserID'],
      colocMembers: json['ColocMembers'],
      description: json['Description'],
      isPermanent: json['IsPermanent'],
      location: json['Location'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
