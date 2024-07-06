import 'package:flutter/cupertino.dart';
import 'package:front/services/colocMember_service.dart';

@immutable
abstract class ColocMemberState {}

class ColocMemberInitial extends ColocMemberState {}

class ColocMemberLoading extends ColocMemberState {}

class ColocMemberLoaded extends ColocMemberState {
  final List<ColocMemberDetail> colocMembers;
  final int currentPage;
  final int totalColocMembers;
  final bool showPagination;
  final Map<int, dynamic> userData;
  final Map<int, dynamic> colocationData;

  ColocMemberLoaded({
    required this.colocMembers,
    required this.currentPage,
    required this.totalColocMembers,
    this.showPagination = true,
    required this.userData,
    required this.colocationData,
  });
}

class ColocMemberError extends ColocMemberState {
  final String message;

  ColocMemberError({required this.message});
}
