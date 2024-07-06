part of 'colocMember_bloc.dart';

@immutable
sealed class ColocMemberEvent {}

class LoadColocMembers extends ColocMemberEvent {
  final int page;
  final int pageSize;

  LoadColocMembers({this.page = 1, this.pageSize = 5});
}
