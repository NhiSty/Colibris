part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);
}

final class TaskError extends TaskState {
  final String message;
  final bool isDirty;

  const TaskError(
    this.message,
    this.isDirty,
  );
}

final class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);
}

final class TaskDeleted extends TaskState {
  final Task task;

  const TaskDeleted(this.task);
}

