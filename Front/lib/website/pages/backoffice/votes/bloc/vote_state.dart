import 'package:flutter/foundation.dart';
import 'package:front/user/user.dart';
import 'package:front/vote/vote.dart';

@immutable
sealed class VoteState {}

class VoteInitial extends VoteState {}
class VoteLoading extends VoteState {}

class VoteLoaded extends VoteState {
  final List<Vote> votes;

  VoteLoaded({ required this.votes });
}

class VoteAdded extends VoteState {
  final String message;

  VoteAdded({required this.message});
}

class VoteUpdated extends VoteState {
  final String message;

  VoteUpdated({required this.message});
}

class VoteError extends VoteState {
  final String message;

  VoteError({required this.message});
}

class Vote422Error extends VoteState {
  final String message;
  final List<Vote> votes;

  Vote422Error({required this.message, required this.votes});
}

class VoteDeleted extends VoteState {
  final String message;
  final int taskId;

  VoteDeleted({required this.message, required this.taskId});
}

class UserColocationLoading extends VoteState {}
class UserColocationLoaded extends VoteState {
  final List<User> users;

  UserColocationLoaded({required this.users});
}

class UserColocationError extends VoteState {
  final String message;

  UserColocationError({required this.message});
}