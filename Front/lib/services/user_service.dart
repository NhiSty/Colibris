import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/dio/dio.dart';
import 'package:front/website/share/secure_storage.dart';

class UserService {
  final Dio _dio = dio;

  Future<List<User>> getAllUsers() async {
    try {
      print('Fetching all users...');
      final response = await _dio.get('/users');

      if (response.statusCode == 200) {
        log('Response data: ${response.data}');
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
      print('Updating user...with the id $userId');
      String? token = await getToken();
      print('token === $token');

      Map<String, dynamic> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.patch('/users/$userId',
          data: userData, options: Options(headers: headers));

      print('here response $response');

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
      print('Deleting user...with the id $userId');
      String? token = await getToken();
      print('token === $token');

      Map<String, dynamic> headers = {};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.delete('/users/$userId',
          options: Options(headers: headers));

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
}

class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      email: json['Email'],
      firstname: json['Firstname'],
      lastname: json['Lastname'],
    );
  }
}
