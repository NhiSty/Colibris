import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/task/task.dart';
import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

class TaskService {
  final Dio _dio = dio;

  Future<int> createTask({
    required String title,
    String description = '',
    required String date,
    required int duration,
    String picture = '',
    required int colocationId
}) async {
    var headers = await addHeader();
    try {
      var userData = await decodeToken();
      var response = await _dio.post(
        '/tasks',
        data: {
          'title': title,
          'description': description,
          'date': date,
          'duration': duration,
          'picture': picture,
          'colocationId': colocationId,
          'userId': userData['user_id'],
        },
        options: Options(headers: headers),
      );
      print(response.data);
      return response.statusCode!;
    } on DioException catch (e) {
      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');
      throw Exception('Failed to create task');
    }
  }

  Future<int> updateTask({
    required int taskId,
    required String title,
    String description = '',
    required String date,
    required int duration,
    String picture = '',
    required int colocationId,
}) async {
    var headers = await addHeader();
    try {
      print('task values: $taskId, $title, $description, $date, $duration, $picture, $colocationId');
      var response = await _dio.put(
        '/tasks/$taskId',
        data: {
          'title': title,
          'description': description,
          'date': date,
          'duration': duration,
          'picture': picture,
          'colocationId': colocationId,
        },
        options: Options(headers: headers),
      );
      return response.statusCode!;
    } on DioException catch (e) {
      log('Dio error!');
      log('error: ${e.response}');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');
      throw Exception('Failed to update task');
    }
  }

  Future<ListTaskResponse> fetchTasks(
      {required int colocationId, int page = 1, int pageSize = 5}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.get(
        '/tasks/colocation/$colocationId',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        List<Task> tasks = (response.data['result'] as List)
            .map((task) => Task.fromJson(task))
            .toList();

        int total = tasks.length;
        return ListTaskResponse(tasks: tasks, total: total);
      } else {
        throw Exception('Failed to load tasks');
      }
    } on DioException catch (e) {
      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<int> deleteTask(int taskId) async {
    var headers = await addHeader();
    try {
      var response = await _dio.delete(
        '/tasks/$taskId',
        options: Options(headers: headers),
      );
      return response.statusCode!;
    } on DioException catch (e) {
      print('Dio error!');
      print('Response status: ${e.response!.statusCode}');
      print('Response data: ${e.response!.data}');
      throw Exception('Failed to delete task');
    }
  }
}

class ListTaskResponse {
  final List<Task> tasks;
  final int total;

  ListTaskResponse({required this.tasks, required this.total});
}