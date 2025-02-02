import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/task/task.dart';
import '../user/user.dart';
import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

class TaskService {
  final Dio _dio = dio;

  Future<ListTaskResponse> searchTasks({required String query}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.get(
        '/tasks/search',
        queryParameters: {
          'query': query,
        },
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        List<Task> tasks = (response.data as List)
            .map((task) => Task.fromJson(task))
            .toList();
        return ListTaskResponse(tasks: tasks, total: tasks.length);
      } else {
        throw Exception('Failed to search tasks');
      }
    } on DioException catch (e) {
      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');
      throw Exception('Failed to search tasks');
    }
  }

  Future<int> createTask({
    required String title,
    String description = '',
    required String date,
    required int duration,
    String picture = '',
    required int colocationId,
    int? userId,
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
          'userId': userId ?? userData['user_id'],
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
    int? userId,
}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.put(
        '/tasks/$taskId',
        data: {
          'title': title,
          'description': description,
          'date': date,
          'duration': duration,
          'picture': picture,
          'colocation_id': colocationId,
          'user_id': userId,
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

  Future<List<Task>> fetchColocationTasks(
      {required int colocationId}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.get(
        '/tasks/colocation/$colocationId',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        List<Task> tasks = (response.data['result'] as List)
            .map((task) => Task.fromJson(task))
            .toList();

        return tasks;
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

  // Get all tasks
  Future<ListTaskResponse> fetchAllTasks(
      {int page = 1, int pageSize = 4}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.get(
        '/tasks',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        List<Task> tasks = (response.data['tasks'] as List)
            .map((task) => Task.fromJson(task))
            .toList();
        final total = response.data['total'];

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

  Future<List<dynamic>> getAllUsers() async {
    var headers = await addHeader();
    final response = await dio.get(
      '/users',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      List<User> users = (response.data['users'] as List)
          .map((user) => User.fromJson(user))
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> getAllColocations() async {
    var headers = await addHeader();
    final response = await dio.get(
      '/colocations',
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      return response.data['colocations'];
    } else {
      throw Exception('Failed to load colocations');
    }
  }
}

class ListTaskResponse {
  final List<Task> tasks;
  final int total;

  ListTaskResponse({required this.tasks, required this.total});
}