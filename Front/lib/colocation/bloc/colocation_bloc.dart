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
    });
  }
}
