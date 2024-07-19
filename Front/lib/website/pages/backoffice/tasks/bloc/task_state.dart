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

class TaskAdded extends TaskState {
  final String message;

  TaskAdded({required this.message});
}

class TaskUpdated extends TaskState {
  final String message;

  TaskUpdated({required this.message});
}

class UsersAndColocationsLoadingForTask extends TaskState {}

class UsersAndColocationsLoadedForTask extends TaskState {
  final List<dynamic> users;
  final List<dynamic> colocations;

  UsersAndColocationsLoadedForTask({
    required this.users,
    required this.colocations,
  });
}

class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}

class TaskSearchEmpty extends TaskState {}
