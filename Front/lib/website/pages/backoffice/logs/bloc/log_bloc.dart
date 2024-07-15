import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/services/log_service.dart';
import 'package:colibris/website/pages/backoffice/logs/bloc/log_state.dart';

part 'log_event.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final LogService logService;

  LogBloc({required this.logService}) : super(LogInitial()) {
    on<FetchLogs>((event, emit) async {
      emit(LogLoading());
      try {
        final logs = await logService.fetchLogs();
        emit(LogLoaded(logs: logs));
      } catch (e, stacktrace) {
        print('FetchLogs error: $e');
        print('Stacktrace: $stacktrace');
        emit(LogError(message: e.toString()));
      }
    });
  }
}
