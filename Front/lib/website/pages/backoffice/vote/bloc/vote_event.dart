part of 'vote_bloc.dart';

@immutable
sealed class VoteEvent {}

class LoadVotes extends VoteEvent {
  final int taskId;

  LoadVotes({required this.taskId});
}

class AddVote extends VoteEvent {
  final int userId;
  final int taskId;
  final int vote;

  AddVote({
    required this.userId,
    required this.taskId,
    required this.vote,
  });
}

class EditVote extends VoteEvent {
  final int voteId;
  final int userId;
  final int taskId;
  final int vote;

  EditVote({
    required this.voteId,
    required this.userId,
    required this.taskId,
    required this.vote,
  });
}

class DeleteVote extends VoteEvent {
  final int voteId;

  DeleteVote({required this.voteId});
}
