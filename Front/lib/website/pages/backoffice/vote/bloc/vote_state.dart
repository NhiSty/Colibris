import 'package:flutter/foundation.dart';
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

class VoteDeleted extends VoteState {
  final String message;

  VoteDeleted({required this.message});
}