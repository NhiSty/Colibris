import 'package:flutter/cupertino.dart';
import 'package:colibris/services/colocMember_service.dart';

@immutable
abstract class ColocMemberState {}

class ColocMemberInitial extends ColocMemberState {}

class ColocMemberLoading extends ColocMemberState {}

class ColocMemberLoaded extends ColocMemberState {
  final List<ColocMemberDetail> colocMembers;
  final int currentPage;
  final int totalColocMembers;
  final bool showPagination;
  final Map<int, dynamic> userData;
  final Map<int, dynamic> colocationData;

  ColocMemberLoaded({
    required this.colocMembers,
    required this.currentPage,
    required this.totalColocMembers,
    this.showPagination = true,
    required this.userData,
    required this.colocationData,
  });
}

class ColocMemberError extends ColocMemberState {
  final String message;

  ColocMemberError({required this.message});
}

class ColocMemberAdded extends ColocMemberState {
  final String message;

  ColocMemberAdded({required this.message});
}

class ColocMemberDeleted extends ColocMemberState {
  final String message;

  ColocMemberDeleted({required this.message});
}

class UsersLoading extends ColocMemberState {}

class UsersLoaded extends ColocMemberState {
  final List<dynamic> users;

  UsersLoaded(this.users);
}

class ColocationsLoading extends ColocMemberState {}

class ColocationsLoaded extends ColocMemberState {
  final List<dynamic> colocations;

  ColocationsLoaded(this.colocations);
}

class UsersAndColocationsLoading extends ColocMemberState {}

class UsersAndColocationsLoaded extends ColocMemberState {
  final List<dynamic> users;
  final List<dynamic> colocations;

  UsersAndColocationsLoaded(this.users, this.colocations);
}
