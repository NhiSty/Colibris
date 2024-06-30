part of 'colocation_bloc.dart';

@immutable
sealed class ColocationEvent {}

class LoadColocations extends ColocationEvent {
  final int page;
  final int pageSize;

  LoadColocations({this.page = 1, this.pageSize = 5});
}

class SearchColocations extends ColocationEvent {
  final String query;

  SearchColocations({required this.query});
}

class ClearSearch extends ColocationEvent {}

class AddColocation extends ColocationEvent {
  final String name;
  final String description;
  final bool isPermanent;
  final double latitude;
  final double longitude;
  final String location;

  AddColocation({
    required this.name,
    required this.description,
    required this.isPermanent,
    required this.latitude,
    required this.longitude,
    required this.location,
  });
}

class EditColocation extends ColocationEvent {
  final int id;
  final String name;
  final String description;
  final bool isPermanent;

  EditColocation({
    required this.id,
    required this.name,
    required this.description,
    required this.isPermanent,
  });
}

class DeleteColocation extends ColocationEvent {
  final int id;

  DeleteColocation({required this.id});
}
