import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/task/task.dart';

import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

Future<int> createTask(String title, String description, String date,
    int duration, String picture, int colocationId) async {
  var headers = await addHeader();
  try {
    var userData = await decodeToken();
    var response = await dio.post(
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
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to create task');
  }
}

Future<int> updateTask(int taskId, String title, String description,
    String date, int duration, String picture, int colocationId) async {
  var headers = await addHeader();
  try {
    var response = await dio.put(
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

Future<List<Task>> fetchTasks(int colocationId) async {
  var headers = await addHeader();
  try {
    var response = await dio.get(
      '/tasks/colocation/$colocationId',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['result'] ?? [];

      return data.map((coloc) => Task.fromJson(coloc)).toList();
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
    var response = await dio.delete(
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
