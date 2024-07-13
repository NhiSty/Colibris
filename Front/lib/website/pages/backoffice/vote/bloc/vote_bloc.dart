import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/vote_service.dart';
import 'vote_state.dart';

part 'vote_event.dart';

class VoteBloc extends Bloc<VoteEvent, VoteState> {
  final VoteService voteService;

  VoteBloc({required this.voteService})
      : super(VoteInitial()) {
    on<LoadVotes>((event, emit) async {
      emit(VoteLoading());
      try {
        final votes = await voteService.fetchVotesByTaskId(event.taskId);
        emit(VoteLoaded(
            votes: votes
        ));
      } catch (e, stacktrace) {
        print('LoadVotes error: $e');
        print('Stacktrace: $stacktrace');
        emit(VoteError(message: e.toString()));
      }
    });

    on<AddVote>((event, emit) async {
      emit(VoteLoading());
      try {
        final response = await voteService.addVote(
          taskId: event.taskId,
          value: event.vote,
        );
        if (response['statusCode'] == 201) {
          emit(VoteAdded(message: 'Vote added successfully'));
        } else {
          emit(VoteError(message: 'Failed to add vote'));
        }
      } catch (e, stacktrace) {

      }
    });

    on<EditVote>((event, emit) async {
      emit(VoteLoading());
      try {
        final response = await voteService.updateVote(event.voteId, event.vote,);
        if (response['statusCode'] == 200) {
          emit(VoteUpdated(message: 'Vote updated successfully'));
        } else {
          emit(VoteError(message: 'Failed to update vote'));
        }
      } catch (e, stacktrace) {
        print('UpdateVote error: $e');
        print('Stacktrace: $stacktrace');
        emit(VoteError(message: e.toString()));
      }
    });

    on<DeleteVote>((event, emit) async {
      emit(VoteLoading());
      try {
        final response = await voteService.deleteVote(event.voteId);
        if (response['statusCode'] == 200) {
          emit(VoteDeleted(message: 'Vote deleted successfully'));
        } else {
          emit(VoteError(message: 'Failed to delete vote'));
        }
      } catch (e, stacktrace) {
        print('DeleteVote error: $e');
        print('Stacktrace: $stacktrace');
        emit(VoteError(message: e.toString()));
      }
    });

  }
}