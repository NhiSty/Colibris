import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:colibris/vote/vote.dart';

import '../vote_service.dart';

part 'vote_state.dart';
part 'vote_event.dart';

class VoteBloc extends Bloc<VoteEvent, CompositeVoteState> {
  VoteBloc() : super(const CompositeVoteState()) {
    on<FetchUserVote>(_onFetchUserVote);
    on<FetchVotesByTaskId>(_onFetchVotesByTaskId);
  }

  Future<void> _onFetchUserVote(
      FetchUserVote event, Emitter<CompositeVoteState> emit) async {
    emit(state.copyWith(voteByUserState: const VoteByUserLoading()));

    try {
      final votes = await fetchUserVotes();
      emit(state.copyWith(voteByUserState: VoteByUserLoaded(votes)));
    } catch (error) {
      emit(state.copyWith(
          voteByUserState:
              VoteByUserError('Failed to fetch votes: $error', true)));
    }
  }

  Future<void> _onFetchVotesByTaskId(
      FetchVotesByTaskId event, Emitter<CompositeVoteState> emit) async {
    emit(state.copyWith(voteByTaskIdState: const VoteByTaskIdLoading()));

    try {
      final votes = await fetchVotesByTaskId(event.taskId);
      emit(state.copyWith(voteByTaskIdState: VoteByTaskIdLoaded(votes)));
    } catch (error) {
      emit(state.copyWith(
          voteByTaskIdState:
              VoteByTaskIdError('Failed to fetch votes: $error')));
    }
  }
}
