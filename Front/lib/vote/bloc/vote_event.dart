part of 'vote_bloc.dart';

sealed class VoteEvent extends Equatable {
  const VoteEvent();

  @override
  List<Object> get props => [];
}

class FetchUserVote extends VoteEvent {
  final int userId;
  const FetchUserVote(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddVote extends VoteEvent {
  final Vote vote;

  const AddVote(this.vote);
}

class DeleteVote extends VoteEvent {
  final Vote vote;

  const DeleteVote(this.vote);
}

class UpdateVote extends VoteEvent {
  final Vote vote;

  const UpdateVote(this.vote);
}