import 'package:bloc/bloc.dart';
import 'package:colibris/invitation/invitation.dart';
import 'package:colibris/invitation/invitation_service.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc() : super(InvitationInitial()) {
    on<InvitationEvent>((event, emit) async {
      if (event is FetchInvitations) {
        emit(InvitationLoading());

        try {
          final invitation = await fetchInvitations();
          emit(InvitationLoaded(invitation));
        } catch (error) {
          emit(InvitationError('Failed to fetch invitation: $error'));
        }
      } else if (event is InvitationAccept) {
        try {
          final response =
              await updateInvitation(event.invitationId, 'accepted');
          if (response == 200) {
            emit(InvitationAccepted(event.invitationId));
          } else {
            emit(InvitationError('Failed to accept invitation'));
          }
        } catch (error) {
          emit(InvitationError('Failed to accept invitation: $error'));
        }
      } else if (event is InvitationReject) {
        try {
          final response =
              await updateInvitation(event.invitationId, 'declined');
          if (response == 200) {
            emit(InvitationRejected(event.invitationId));
          } else {
            emit(InvitationError('Failed to reject invitation'));
          }
        } catch (error) {
          emit(InvitationError('Failed to reject invitation: $error'));
        }
      } else if (event is InvitationClearError) {
        emit(InvitationInitial());
      } else if (event is InvitationClear) {
        emit(InvitationInitial());
      } else if (event is InvitationUpdate) {
        try {
          final response = await updateInvitation(
              event.invitation.id, event.invitation.state);
          if (response == 200) {
            emit(InvitationLoaded(await fetchInvitations()));
          } else {
            emit(InvitationError('Failed to update invitation'));
          }
        } catch (error) {
          emit(InvitationError('Failed to update invitation: $error'));
        }
      }
    });
  }
}
