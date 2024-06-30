part of 'colocation_bloc.dart';

sealed class ColocationEvent extends Equatable {
  const ColocationEvent();

  @override
  List<Object> get props => [];
}

class FetchColocations extends ColocationEvent {
  const FetchColocations();
}

class ColocationCreate extends ColocationEvent {
  final Colocation colocation;

  const ColocationCreate(this.colocation);
}

class ColocationDelete extends ColocationEvent {
  final Colocation colocation;

  ColocationDelete(this.colocation);
}

class ColocationUpdate extends ColocationEvent {
  final Colocation colocation;

  ColocationUpdate(this.colocation, {required colocationId});
}

class ColocationJoin extends ColocationEvent {
  final int colocationId;

  ColocationJoin(this.colocationId);
}

class ColocationLeave extends ColocationEvent {
  final int colocationId;

  ColocationLeave(this.colocationId);
}

class ColocationInvite extends ColocationEvent {
  final int colocationId;
  final String email;

  ColocationInvite({required this.colocationId, required this.email});
}
