part of 'colocMember_bloc.dart';

@immutable
sealed class ColocMemberEvent {}

class LoadColocMembers extends ColocMemberEvent {
  final int page;
  final int pageSize;

  LoadColocMembers({this.page = 1, this.pageSize = 5});
}

class SearchColocMembers extends ColocMemberEvent {
  final String query;
  final int page;
  final int pageSize;

  SearchColocMembers({required this.query, this.page = 1, this.pageSize = 5});
}

class AddColocMember extends ColocMemberEvent {
  final int userId;
  final int colocationId;

  AddColocMember({required this.userId, required this.colocationId});
}

class LoadAllUsers extends ColocMemberEvent {}

class LoadAllColocations extends ColocMemberEvent {}

class LoadAllUsersAndColocations extends ColocMemberEvent {}
