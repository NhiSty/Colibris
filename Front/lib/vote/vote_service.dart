import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/vote/vote.dart';
import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

Future<int> addVote(String taskId, int value) async {
  var headers = await addHeader();
  try {
    var response = await dio.post(
      '/votes',
      data: {
        'taskId': taskId,
        'value': value,
      },
      options: Options(headers: headers),
    );
    print(response.data);
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to add vote on task with id $taskId');
  }
}

Future<List<Vote>> fetchUserVotes() async {
  var headers = await addHeader();
  var userData = await decodeToken();
  try {
    var response = await dio.get(
      '/votes/${userData['user_id']}',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['result'] ?? [];

      return data.map((coloc) => Vote.fromJson(coloc)).toList();
    } else {
      throw Exception('Failed to load votes for user ${userData['user_id']}');
    }
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to fetch votes for user ${userData['user_id']}');
  }
}
