import 'dart:developer';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:front/utils/dio.dart';
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
      await deleteToken();
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

Future<int?> addFcmToken(String token) async {
  var headers = await addHeader();
  try {
    var response = await dio.patch("/users/add-fcm-token", options: Options(headers: headers), data: {
      "fcm_token": token
    });
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return 500;
    }
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    throw Exception('Failed to load feature flags');
  }
}

Future<int> signWithGoogle(
    String email, String name, String token, String provider) async {
  try {
    print("object $name $email");

    final response = await dio.post('/auth/validate-token', data: {
      'email': email,
      'name': name,
      'token': token,
      'provider': provider,
    });

    if (response.data.containsKey('token')) {
      var apiToken = response.data['token'];
      await deleteToken();
      await saveToken(apiToken);
    } else {
      log('Token non trouvé dans la réponse');
      return 500;
    }

    return response.statusCode!;
  } on DioException catch (e) {
    log('Erreur Dio!');
    log('Statut de la réponse: ${e.response!.statusCode}');
    log('Données de la réponse: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}
