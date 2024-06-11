part of 'invitation_bloc.dart';

@immutable
sealed class InvitationState {}

final class InvitationInitial extends InvitationState {}

final class InvitationLoading extends InvitationState {}

final class InvitationLoaded extends InvitationState {
  final List<Invitation> invitations;

  InvitationLoaded(this.invitations);
}

final class InvitationError extends InvitationState {
  final String message;

  InvitationError(this.message);
}

final class InvitationCreated extends InvitationState {
  final Invitation invitation;

  InvitationCreated(this.invitation);
}

final class InvitationDeleted extends InvitationState {
  final Invitation invitation;

  InvitationDeleted(this.invitation);
}

final class InvitationAccepted extends InvitationState {
  final int invitationId;

  InvitationAccepted(this.invitationId);
}

final class InvitationRejected extends InvitationState {
  final int invitationId;

  InvitationRejected(this.invitationId);
}
