
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:front/vote/vote.dart';

import '../vote_service.dart';

part 'vote_state.dart';
part 'vote_event.dart';

class VoteBloc extends Bloc<VoteEvent, VoteState> {
  VoteBloc() : super(const VoteInitial()) {
    on<VoteEvent>((event, emit) async {
      if (event is FetchUserVote) {
        emit(const VoteLoading());

        try {
          final votes = await fetchUserVotes();
          emit(VoteLoaded(votes));
        } catch (error) {
          emit(VoteError('Failed to fetch votes: $error', true));
        }
      } else if (event is VoteInitial) {
        emit(const VoteInitial());
      }
    });
  }
}