
import 'dart:developer';

import 'package:dio/dio.dart';
import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

Future<int> createTask(String title, String description, String date, int duration, String picture, int colocationId) async {
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
    print(response.data);
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to create task');
  }
}