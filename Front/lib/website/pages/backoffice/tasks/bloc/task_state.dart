import 'package:flutter/foundation.dart';
import 'package:front/task/task.dart';

@immutable
sealed class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final int currentPage;
  final int totalTasks;
  final bool showPagination;

  TaskLoaded({
    required this.tasks,
    required this.currentPage,
    required this.totalTasks,
    this.showPagination = true,
  });
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}

class TaskSearchEmpty extends TaskState {}
