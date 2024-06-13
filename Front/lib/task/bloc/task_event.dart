part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class FetchTasks extends TaskEvent {
  final int colocationId;
  const FetchTasks(this.colocationId);

  @override
  List<Object> get props => [colocationId];
}

class TaskCreate extends TaskEvent {
  final Task task;

  const TaskCreate(this.task);
}

class TaskDelete extends TaskEvent {
  final Task task;

  TaskDelete(this.task);
}

class TaskUpdate extends TaskEvent {
  final Task task;

  TaskUpdate(this.task);
}