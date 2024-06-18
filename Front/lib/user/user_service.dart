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
    final response = await _dio.get('/users');

    if (response.statusCode == 200) {
      List<User> users =
          (response.data as List).map((user) => User.fromJson(user)).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    log('Dio error!');
    log('Response status: ${e.response?.statusCode}');
    log('Response data: ${e.response?.data}');
    throw Exception('Failed to load users');
  }
}

Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
  try {
    var headers = await addHeader();

    final response = await dio.patch('/users/$userId',
        data: userData, options: Options(headers: headers));

    if (response.statusCode == 200) {
      log('User updated successfully');
    } else {
      throw Exception('Failed to update user');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    log('Dio error!');
    log('Response status: ${e.response?.statusCode}');
    log('Response data: ${e.response?.data}');
    throw Exception('Failed to update user');
  }
}

Future<void> deleteUser(int userId) async {
  try {
    var headers = await addHeader();

    final response =
        await _dio.delete('/users/$userId', options: Options(headers: headers));

    if (response.statusCode == 200) {
      log('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    log('Dio error!');
    log('Response status: ${e.response?.statusCode}');
    log('Response data: ${e.response?.data}');
    throw Exception('Failed to delete user');
  }
}

Future<List<User>> findUserInColoc(int colocId) async {
  try {
    final users = await getAllUsers();
    final colocRes = await fetchColoMembersByColoc(colocId);
    if (users.isNotEmpty && colocRes.isNotEmpty) {
      List<ColocMembers> colocMembers = colocRes.map((coloc) => coloc).toList();

      List<User> usersInColoc = users.where((user) {
        return colocMembers.any((colocMember) {
          return colocMember.userId == user.id;
        });
      }).toList();

      for (var user in usersInColoc) {
        for (var colocMember in colocMembers) {
          if (colocMember.userId == user.id) {
            user.colocMemberId = colocMember.id;
            user.colocationId = colocMember.colocationId;
          }
        }
      }

      return usersInColoc;
    }
    return [];
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    log('Dio error!');
    log('Response status: ${e.response?.statusCode}');
    log('Response data: ${e.response?.data}');
    throw Exception('Failed to load users');
  }
}

Future<Map<String, dynamic>> getUserById(int userId) async {
  try {
    var headers = await addHeader();

    print('Fetching user data...');
    final response =
        await _dio.get('/users/$userId', options: Options(headers: headers));

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load user data');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    print('Dio error!');
    print('Response status: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    throw Exception('Failed to load user data');
  }
}
