import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/ColocMembers/colocMembers.dart';
import 'package:front/ColocMembers/colocMembers_service.dart';
import 'package:front/user/user.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

final Dio _dio = dio;

Future<List<User>> getAllUsers() async {
  try {
    var headers = await addHeader();
    final response =
        await _dio.get('/users', options: Options(headers: headers));

    if (response.statusCode == 200) {
      List<User> users =
          (response.data as List).map((user) => User.fromJson(user)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  } on DioException catch (e) {
    _handleDioError(e);
    throw Exception('Failed to load users');
  }
}

Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
  try {
    var headers = await addHeader();
    final response = await _dio.patch('/users/$userId',
        data: userData, options: Options(headers: headers));

    if (response.statusCode == 200) {
      log('User updated successfully');
    } else {
      throw Exception('Failed to update user');
    }
  } on DioException catch (e) {
    _handleDioError(e);
    throw Exception('Failed to update user');
  }
}

Future<void> deleteUser(int userId) async {
  try {
    var headers = await addHeader();
    final response =
        await _dio.delete('/users/$userId', options: Options(headers: headers));

    if (response.statusCode == 204) {
      log('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  } on DioException catch (e) {
    _handleDioError(e);
    throw Exception('Failed to delete user');
  }
}

Future<List<User>> findUserInColoc(int colocId) async {
  try {
    final res = await fetchColoMembersByColoc(colocId);

    if (res.statusCode == 200) {
      print(res.data["result"]);
      List<dynamic> data = res.data["result"];
      List<User> users = data.map((user) => User.fromJson(user)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  } on DioException catch (e) {
    _handleDioError(e);
    throw Exception('Failed to load users');
  }
}

Future<Map<String, dynamic>> getUserById(int userId) async {
  try {
    var headers = await addHeader();
    final response =
        await _dio.get('/users/$userId', options: Options(headers: headers));

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load user data');
    }
  } on DioException catch (e) {
    _handleDioError(e);
    throw Exception('Failed to load user data');
  }
}

void _handleDioError(DioException e) {
  log('Dio error!');
  print('Error: ${e.response?.statusCode}');
  print('Response data: ${e.response?.data}');
  log('Response status: ${e.response?.statusCode}');
  log('Response data: ${e.response?.data}');
}
