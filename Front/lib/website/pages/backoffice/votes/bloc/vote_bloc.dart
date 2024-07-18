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
        print('taskId: ${event.taskId}');
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
          userId: event.userId,
        );
        if (response['statusCode'] == 201) {
          emit(VoteAdded(message: 'backoffice_vote_vote_added_successfully'.tr()));
        } else {
          emit(VoteError(message: response['data']));
        }
      } catch (e, stacktrace) {
        print('UpdateVote error: $e');
        print('Stacktrace: $stacktrace');
        emit(VoteError(message: e.toString()));
      }
    });

    on<EditVote>((event, emit) async {
      emit(VoteLoading());
      try {
        final response = await voteService.updateVote(event.voteId, event.vote);
        if (response['statusCode'] == 200) {
          emit(VoteUpdated(message: 'Vote updated successfully'));
        } else
        if (response['statusCode'] == 422 ) {
          print('response: $response');
          emit(Vote422Error(message: response['message'], votes: []));
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
        if (response['statusCode'] == 204) {
          emit(VoteDeleted(
              message: 'backoffice_vote_vote_deleted_successfully'.tr(),
              taskId: event.taskId
          ));
        } else {
          emit(VoteError(message: 'Failed to delete vote'));
        }
      } catch (e, stacktrace) {
        print('DeleteVote error: $e');
        print('Stacktrace: $stacktrace');
        emit(VoteError(message: e.toString()));
      }
    });

    on<LoadUsersColocation>((event, emit) async {
      emit(UserColocationLoading());
      try {
        final _users = await voteService.fetchUserByTaskId(event.taskId);
        emit(UserColocationLoaded(users: _users));
      } catch (e, stacktrace) {
        print('LoadUserColocation error: $e');
        print('Stacktrace: $stacktrace');
        emit(UserColocationError(message: e.toString()));
      }
    });

  }
}