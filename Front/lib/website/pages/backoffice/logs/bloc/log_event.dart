part of 'log_bloc.dart';

@immutable
sealed class LogEvent {}

class FetchLogs extends LogEvent {}
