import 'package:flutter/foundation.dart';
import 'package:colibris/services/user_service.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int currentPage;
  final int totalUsers;
  final bool showPagination;

  UserLoaded({
    required this.users,
    required this.currentPage,
    required this.totalUsers,
    this.showPagination = true,
  });
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}

class UserSearchEmpty extends UserState {}
