import 'package:flutter/cupertino.dart';
import 'package:colibris/services/log_service.dart';

@immutable
abstract class LogState {}

class LogInitial extends LogState {}

class LogLoading extends LogState {}

class LogLoaded extends LogState {
  final List<Log> logs;

  LogLoaded({required this.logs});
}

class LogError extends LogState {
  final String message;

  LogError({required this.message});
}
