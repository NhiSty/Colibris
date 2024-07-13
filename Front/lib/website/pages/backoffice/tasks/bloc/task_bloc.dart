import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/task_service.dart';

import '../../../../../task/task.dart';
import 'task_state.dart';

part 'task_event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskBloc({required this.taskService})
      : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final response = await taskService.fetchAllTasks(
          page: event.page,
          pageSize: event.pageSize,
        );
        final tasks = response.tasks;
        final totalTasks = response.total;
        emit(TaskLoaded(
          tasks: tasks,
          currentPage: event.page,
          totalTasks: totalTasks,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('LoadTasks error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<SearchTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final taskServiceResponse = await taskService.searchTasks(query: event.query);
        emit(TaskLoaded(
          tasks: taskServiceResponse.tasks,
          currentPage: 1,
          totalTasks: taskServiceResponse.total,
          showPagination: false,
        ));
      } catch (e, stacktrace) {
        print('SearchTasks error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<ClearSearch>((event, emit) async {
      emit(TaskLoading());
      try {
        final response = await taskService.fetchAllTasks();
        final tasks = response.tasks;
        final totalTasks = response.total;
        emit(TaskLoaded(
          tasks: tasks,
          currentPage: 1,
          totalTasks: totalTasks,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('ClearSearch error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<AddTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await taskService.createTask(
          title: event.title,
          description: event.description,
          date: event.date,
          duration: event.duration,
          picture: event.picture,
          colocationId: event.colocationId,
        );
        await taskService.fetchAllTasks();
        emit(TaskAdded(
          message: 'backoffice_task_task_added_successfully'.tr(),
        ));
      } catch (e, stacktrace) {
        print('AddTask error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<EditTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await taskService.updateTask(
          taskId: event.taskId,
          title: event.title,
          description: event.description,
          date: event.date,
          duration: event.duration,
          picture: event.picture,
          colocationId: event.colocationId,
          userId: event.userId,
        );
        final response = await taskService.fetchAllTasks();
        final tasks = response.tasks;
        final totalTasks = response.total;
        emit(TaskLoaded(
          tasks: tasks,
          currentPage: 1,
          totalTasks: totalTasks,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('EditTask error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await taskService.deleteTask(event.id);
        final response = await taskService.fetchAllTasks();
        final tasks = response.tasks;
        final totalTasks = response.total;
        emit(TaskLoaded(
          tasks: tasks,
          currentPage: 1,
          totalTasks: totalTasks,
          showPagination: true,
        ));
      } catch (e, stacktrace) {
        print('DeleteTask error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });

    on<LoadAllUsersAndColocations>((event, emit) async {
      emit(UsersAndColocationsLoading());
      try {
        final users = await taskService.getAllUsers();
        final colocations = await taskService.getAllColocations();
        emit(UsersAndColocationsLoaded(
          users: users,
          colocations: colocations,
        ));
      } catch (e, stacktrace) {
        print('LoadAllUsersAndColocations error: $e');
        print('Stacktrace: $stacktrace');
        emit(TaskError(message: e.toString()));
      }
    });
  }
}
