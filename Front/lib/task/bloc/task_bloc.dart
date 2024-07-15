import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:colibris/task/task.dart';

import '../task_service.dart';

part 'task_state.dart';
part 'task_event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    on<TaskEvent>((event, emit) async {
      if (event is FetchTasks) {
        emit(const TaskLoading());

        try {
          print('fetching tasks for colocation ${event.colocationId}');
          final tasks = await fetchTasks(event.colocationId);
          emit(TaskLoaded(tasks));
        } catch (error) {
          emit(TaskError('Failed to fetch tasks: $error', true));
        }
      } else if (event is TaskInitial) {
        emit(const TaskInitial());
      }
    });
  }
}
