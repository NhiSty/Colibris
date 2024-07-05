part of 'vote_bloc.dart';

sealed class VoteState extends Equatable {
  const VoteState();

  @override
  List<Object> get props => [];
}

final class VoteInitial extends VoteState {
  const VoteInitial();
}

final class VoteLoading extends VoteState {
  const VoteLoading();
}

final class VoteLoaded extends VoteState {
  final List<Vote> votes;

  const VoteLoaded(this.votes);
}

final class VoteError extends VoteState {
  final String message;
  final bool isDirty;

  const VoteError(
    this.message,
    this.isDirty,
  );
}

final class VoteAdded extends VoteState {
  final Vote vote;

  const VoteAdded(this.vote);
}

final class VoteDeleted extends VoteState {
  final Vote vote;

  const VoteDeleted(this.vote);
}

