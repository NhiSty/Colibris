import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/services/colocMember_service.dart';

import 'colocMember_state.dart';

part 'colocMember_event.dart';

class ColocMemberBloc extends Bloc<ColocMemberEvent, ColocMemberState> {
  final ColocMemberService colocMemberService;

  ColocMemberBloc({required this.colocMemberService})
      : super(ColocMemberInitial()) {
    on<LoadColocMembers>((event, emit) async {
      emit(ColocMemberLoading());
      try {
        final response = await colocMemberService.getAllColocMembers(
          page: event.page,
          pageSize: event.pageSize,
        );
        final colocMembers = response.colocMembers;
        final totalColocMembers = response.total;
        final userData = response.userData;
        final colocationData = response.colocationData;

        emit(ColocMemberLoaded(
          colocMembers: colocMembers,
          currentPage: event.page,
          totalColocMembers: totalColocMembers,
          showPagination: true,
          userData: userData,
          colocationData: colocationData,
        ));
      } catch (e, stacktrace) {
        print('LoadColocMembers error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<SearchColocMembers>((event, emit) async {
      emit(ColocMemberLoading());
      try {
        final response = await colocMemberService.getAllColocMembers(
          page: event.page,
          pageSize: event.pageSize,
          query: event.query,
        );
        final colocMembers = response.colocMembers;
        final totalColocMembers = response.total;
        final userData = response.userData;
        final colocationData = response.colocationData;

        emit(ColocMemberLoaded(
          colocMembers: colocMembers,
          currentPage: event.page,
          totalColocMembers: totalColocMembers,
          showPagination: true,
          userData: userData,
          colocationData: colocationData,
        ));
      } catch (e, stacktrace) {
        print('SearchColocMembers error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<AddColocMember>((event, emit) async {
      try {
        await colocMemberService.addColocMember(
            event.userId, event.colocationId);
        emit(ColocMemberAdded(message: 'Colocation member added successfully'));
        add(LoadColocMembers());
      } catch (e, stacktrace) {
        print('AddColocMember error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<LoadAllUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await colocMemberService.getAllUsers();
        emit(UsersLoaded(users));
      } catch (e, stacktrace) {
        print('LoadAllUsers error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<LoadAllColocations>((event, emit) async {
      emit(ColocationsLoading());
      try {
        final colocations = await colocMemberService.getAllColocations();
        emit(ColocationsLoaded(colocations));
      } catch (e, stacktrace) {
        print('LoadAllColocations error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<LoadAllUsersAndColocations>((event, emit) async {
      emit(UsersAndColocationsLoading());
      try {
        final users = await colocMemberService.getAllUsers();
        final colocations = await colocMemberService.getAllColocations();
        emit(UsersAndColocationsLoaded(users, colocations));
      } catch (e, stacktrace) {
        print('LoadAllUsersAndColocations error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<UpdateColocMemberScore>((event, emit) async {
      try {
        await colocMemberService.updateColocMemberScore(
            event.colocMemberId, event.newScore);
        emit(ColocMemberAdded(
            message: 'Colocation member score updated successfully'));
        add(LoadColocMembers());
      } catch (e, stacktrace) {
        print('UpdateColocMemberScore error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });

    on<DeleteColocMember>((event, emit) async {
      try {
        await colocMemberService.deleteColocMember(event.colocMemberId);
        emit(ColocMemberAdded(
            message: 'Colocation member deleted successfully'));
        add(LoadColocMembers());
      } catch (e, stacktrace) {
        print('DeleteColocMember error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocMemberError(message: e.toString()));
      }
    });
  }
}
