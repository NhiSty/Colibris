import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/vote/vote.dart';
import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

Future<int> addVote(int taskId, int value) async {
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
      '/votes/users/${userData['user_id']}',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['votes'] ?? [];

      return data.map((vote) => Vote.fromJson(vote)).toList();
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

Future<int> updateVote(int voteId, int value) async {
  var headers = await addHeader();

  try {
    var response = await dio.put(
      '/votes/$voteId',
      options: Options(headers: headers),
      data: {
        'value': value
      }
    );
    return response.statusCode!;

  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to update vote with id : $voteId');
  }
}
