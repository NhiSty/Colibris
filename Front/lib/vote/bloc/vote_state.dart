part of 'vote_bloc.dart';

sealed class VoteState extends Equatable {
  const VoteState();

  @override
  List<Object> get props => [];
}

class CompositeVoteState extends Equatable {
  final VoteState voteByUserState;
  final VoteState voteByTaskIdState;

  const CompositeVoteState({
    this.voteByUserState = const VoteByUserInitial(),
    this.voteByTaskIdState = const VoteByTaskIdLoading(),
  });

  CompositeVoteState copyWith({
    VoteState? voteByUserState,
    VoteState? voteByTaskIdState,
  }) {
    return CompositeVoteState(
      voteByUserState: voteByUserState ?? this.voteByUserState,
      voteByTaskIdState: voteByTaskIdState ?? this.voteByTaskIdState,
    );
  }

  @override
  List<Object> get props => [voteByUserState, voteByTaskIdState];
}


final class VoteByUserInitial extends VoteState {
  const VoteByUserInitial();
}

final class VoteByUserLoading extends VoteState {
  const VoteByUserLoading();
}

final class VoteByUserLoaded extends VoteState {
  final List<Vote> votes;

  const VoteByUserLoaded(this.votes);
}

final class VoteByTaskIdLoading extends VoteState {
  const VoteByTaskIdLoading();
}

final class VoteByTaskIdLoaded extends VoteState {
  final List<Vote> votes;

  const VoteByTaskIdLoaded(this.votes);
}

final class VoteByTaskIdError extends VoteState {
  final String message;

  const VoteByTaskIdError(this.message);
}

final class VoteByUserError extends VoteState {
  final String message;
  final bool isDirty;

  const VoteByUserError(
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

