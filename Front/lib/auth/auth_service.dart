import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/dio/dio.dart';
import 'package:front/website/share/secure_storage.dart';

Future<int> login(String email, String password) async {
  Response response;

  try {
    response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    if (response.data.containsKey('token')) {
      var token = response.data['token'];
      await saveToken(token);
    } else {
      log('Token not found in the response');
      return 500;
    }

    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}

Future<int> register(
    String email, String password, String firstname, String lastname) async {
  try {
    var response = await dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname
      },
    );
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}

Future<int> resetPassword(String email) async {
  try {
    var response = await dio.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}

Future<int?> checkConfirmationCode(String password) async {
  try {
    final response = await dio.get('/auth/ask-reset-password/$password');

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Code does not exist');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    print('Dio error!');
    print('Response status: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    throw Exception('Failed to check confirmation code');
  }
}

Future<int?> resetPasswordWithCode(String password, String email_code) async {
  try {
    final response = await dio.post('/auth/reset-password', data: {
      'new_password': password,
      'token': email_code,
    });

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      throw Exception('Failed to reset password');
    }
  } on DioException catch (e) {
    print('Error: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    print('Dio error!');
    print('Response status: ${e.response?.statusCode}');
    print('Response data: ${e.response?.data}');
    throw Exception('Failed to reset password');
  }
}
