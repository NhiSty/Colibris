part of 'colocation_bloc.dart';

sealed class ColocationState extends Equatable {
  const ColocationState();

  @override
  List<Object> get props => [];
}

final class ColocationInitial extends ColocationState {
  const ColocationInitial();
}

final class ColocationLoading extends ColocationState {
  const ColocationLoading();
}

final class ColocationLoaded extends ColocationState {
  final List<Colocation> colocations;

  const ColocationLoaded(this.colocations);
}

final class ColocationError extends ColocationState {
  final String message;
  final bool isDirty;

  const ColocationError(
    this.message,
    this.isDirty,
  );
}

final class ColocationCreated extends ColocationState {
  final Colocation colocation;

  const ColocationCreated(this.colocation);
}

final class ColocationDeleted extends ColocationState {
  final Colocation colocation;

  const ColocationDeleted(this.colocation);
}

final class ColocationUpdated extends ColocationState {
  final Colocation colocation;

  const ColocationUpdated(this.colocation);
}

final class ColocationJoined extends ColocationState {
  final Colocation colocation;

  const ColocationJoined(this.colocation);
}

final class ColocationLeft extends ColocationState {
  final Colocation colocation;

  const ColocationLeft(this.colocation);
}

final class ColocationInvited extends ColocationState {
  final Colocation colocation;

  const ColocationInvited(this.colocation);
}
