import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/services/colocation_service.dart';

import 'colocation_state.dart';

part 'colocation_event.dart';

class ColocationBloc extends Bloc<ColocationEvent, ColocationState> {
  final ColocationService colocationService;

  ColocationBloc({required this.colocationService})
      : super(ColocationInitial()) {
    on<LoadColocations>((event, emit) async {
      emit(ColocationLoading());
      try {
        final response = await colocationService.getAllColocations(
          page: event.page,
          pageSize: event.pageSize,
        );
        final colocations = response.colocations;
        final totalColocations = response.total;
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: event.page,
          totalColocations: totalColocations,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('LoadColocations error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });

    on<SearchColocations>((event, emit) async {
      emit(ColocationLoading());
      try {
        final colocations =
            await colocationService.searchColocations(query: event.query);
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: 1,
          totalColocations: colocations.length,
          showPagination: false,
        ));
      } catch (e, stacktrace) {
        print('SearchColocations error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });

    on<ClearSearch>((event, emit) async {
      emit(ColocationLoading());
      try {
        final response = await colocationService.getAllColocations();
        final colocations = response.colocations;
        final totalColocations = response.total;
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: 1,
          totalColocations: totalColocations,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('ClearSearch error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });

    on<AddColocation>((event, emit) async {
      emit(ColocationLoading());
      try {
        await colocationService.createColocation(
          name: event.name,
          description: event.description,
          isPermanent: event.isPermanent,
          latitude: event.latitude,
          longitude: event.longitude,
          location: event.location,
        );
        final response = await colocationService.getAllColocations();
        final colocations = response.colocations;
        final totalColocations = response.total;
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: 1,
          totalColocations: totalColocations,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('AddColocation error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });

    on<EditColocation>((event, emit) async {
      emit(ColocationLoading());
      try {
        await colocationService.updateColocation(
          event.id,
          {
            'name': event.name,
            'description': event.description,
            'isPermanent': event.isPermanent,
          },
        );
        final response = await colocationService.getAllColocations();
        final colocations = response.colocations;
        final totalColocations = response.total;
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: 1,
          totalColocations: totalColocations,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('EditColocation error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });

    on<DeleteColocation>((event, emit) async {
      emit(ColocationLoading());
      try {
        await colocationService.deleteColocation(event.id);
        final response = await colocationService.getAllColocations();
        final colocations = response.colocations;
        final totalColocations = response.total;
        emit(ColocationLoaded(
          colocations: colocations,
          currentPage: 1,
          totalColocations: totalColocations,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('DeleteColocation error: $e');
        print('Stacktrace: $stacktrace');
        emit(ColocationError(message: e.toString()));
      }
    });
  }
}
