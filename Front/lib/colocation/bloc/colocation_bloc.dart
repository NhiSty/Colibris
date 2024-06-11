import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/colocation/colocation_service.dart';

part 'colocation_event.dart';
part 'colocation_state.dart';

class ColocationBloc extends Bloc<ColocationEvent, ColocationState> {
  ColocationBloc() : super(const ColocationInitial()) {
    on<ColocationEvent>((event, emit) async {
      if (event is FetchColocations) {
        emit(const ColocationLoading());

        try {
          final colocations = await fetchColocations();
          emit(ColocationLoaded(colocations));
        } catch (error) {
          emit(ColocationError('Failed to fetch colocations: $error', true));
        }
      } else if (event is ColocationInitial) {
        emit(const ColocationInitial());
      }
      /* else if (event is ColocationCreate) {
        try {
          final colocation = createColocation(event.colocation);
          emit(ColocationCreated(colocation));
        } catch (error) {
          emit(ColocationError('Failed to create colocation: $error'));
        }
      } else if (event is ColocationDelete) {
        try {
          final colocation = deleteColocation(event.colocation);
          emit(ColocationDeleted(colocation));
        } catch (error) {
          emit(ColocationError('Failed to delete colocation: $error'));
        }
      } else if (event is ColocationUpdate) {
        try {
          final colocation = updateColocation(event.colocation);
          emit(ColocationUpdated(colocation));
        } catch (error) {
          emit(ColocationError('Failed to update colocation: $error'));
        }
      } else if (event is ColocationJoin) {
        try {
          final colocation = joinColocation(event.colocationId);
          emit(ColocationJoined(colocation));
        } catch (error) {
          emit(ColocationError('Failed to join colocation: $error'));
        }
      } else if (event is ColocationLeave) {
        try {
          final colocation = leaveColocation(event.colocationId);
          emit(ColocationLeft(colocation));
        } catch (error) {
          emit(ColocationError('Failed to leave colocation: $error'));
        }
      } else if (event is ColocationInvite) {
        try {
          final colocation = inviteColocation(event.colocationId, event.email);
          emit(ColocationInvited(colocation));
        } catch (error) {
          emit(ColocationError('Failed to invite colocation: $error'));
        }
      }*/
    });
  }
}
