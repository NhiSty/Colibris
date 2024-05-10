import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:front/dio/dio.dart';




Future<int> login(String email, String password) async {
  Response response;

  try {
    response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
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
    log('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}
