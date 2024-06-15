import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

class UserService {
  final Dio _dio = dio;

  Future<UserResponse> getAllUsers({int page = 1, int pageSize = 5}) async {
    var headers = await addHeader();
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<User> users = (response.data['users'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        int total = response.data['total'];
        return UserResponse(users: users, total: total);
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

  Future<List<User>> searchUsers({required String query}) async {
    try {
      final response = await _dio.get(
        '/users/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        List<User> users =
            (response.data as List).map((user) => User.fromJson(user)).toList();
        return users;
      } else {
        throw Exception('Failed to search users');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to search users');
    }
  }

  Future<void> register(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'email': email,
          'password': password,
          'firstname': firstName,
          'lastname': lastName,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to register user');
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
}

class UserResponse {
  final List<User> users;
  final int total;

  UserResponse({required this.users, required this.total});
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
