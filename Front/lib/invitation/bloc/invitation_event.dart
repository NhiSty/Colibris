part of 'invitation_bloc.dart';

@immutable
sealed class InvitationEvent {}

class FetchInvitations extends InvitationEvent {
  FetchInvitations();
}

class InvitationCreate extends InvitationEvent {
  final Invitation invitation;

  InvitationCreate(this.invitation);
}

class InvitationDelete extends InvitationEvent {
  final Invitation invitation;

  InvitationDelete(this.invitation);
}

class InvitationAccept extends InvitationEvent {
  final String state;
  final int invitationId;

  InvitationAccept({required this.state, required this.invitationId});
}

class InvitationReject extends InvitationEvent {
  final String state;
  final int invitationId;
  InvitationReject({required this.state, required this.invitationId});
}

class InvitationErrorEvent extends InvitationEvent {
  final String message;

  InvitationErrorEvent(this.message);
}

class InvitationClearError extends InvitationEvent {
  InvitationClearError();
}

class InvitationClear extends InvitationEvent {
  InvitationClear();
}

class InvitationUpdate extends InvitationEvent {
  final Invitation invitation;

  InvitationUpdate(this.invitation);
}
