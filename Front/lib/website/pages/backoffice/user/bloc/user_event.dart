part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUsers extends UserEvent {
  final int page;
  final int pageSize;

  LoadUsers({this.page = 1, this.pageSize = 5});
}

class SearchUsers extends UserEvent {
  final String query;

  SearchUsers({required this.query});
}

class ClearSearch extends UserEvent {}

class AddUser extends UserEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  AddUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class EditUser extends UserEvent {
  final String id;
  final String firstName;
  final String lastName;

  EditUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });
}

class DeleteUser extends UserEvent {
  final String id;

  DeleteUser({required this.id});
}
