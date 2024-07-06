import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/colocMember_service.dart';

import 'colocMember_state.dart';

part 'colocMember_event.dart';

class ColocMemberBloc extends Bloc<ColocMemberEvent, ColocMemberState> {
  final ColocMemberService colocMemberService;

  ColocMemberBloc({required this.colocMemberService})
      : super(ColocMemberInitial()) {
    on<LoadColocMembers>(_onLoadColocMembers);
  }

  Future<void> _onLoadColocMembers(
      LoadColocMembers event, Emitter<ColocMemberState> emit) async {
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
  }
}
