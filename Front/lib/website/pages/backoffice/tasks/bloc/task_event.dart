part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadTasks extends TaskEvent {
  final int page;
  final int pageSize;

  LoadTasks({this.page = 1, this.pageSize = 4});
}

class SearchTasks extends TaskEvent {
  final String query;

  SearchTasks({required this.query});
}

class ClearSearch extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  final String date;
  final int duration;
  final String picture;
  final int colocationId;
  final int? userId;

  AddTask({
    required this.title,
    this.description = '',
    required this.date,
    required this.duration,
    this.picture = '',
    required this.colocationId,
    this.userId = null,
  });
}

class EditTask extends TaskEvent {
  final int taskId;
  final String title;
  final String description;
  final String date;
  final int duration;
  final String picture;
  final int colocationId;
  final int? userId;

  EditTask({
    required this.taskId,
    required this.title,
    this.description = '',
    required this.date,
    required this.duration,
    this.picture = '',
    required this.colocationId,
    this.userId = null,
  });
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask({required this.id});
}

class LoadAllUsersAndColocationsForTask extends TaskEvent {}