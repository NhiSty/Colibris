import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/vote/vote.dart';

import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

Future<dynamic> addVote(int taskId, int value) async {
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

    return {
      'statusCode': response.statusCode,
      'data': response.data,
    };
  } on DioException catch (e) {
    if (e.response?.statusCode == 422) {
      return {
        'statusCode': 422,
        'data': e.response?.data,
      };
    }

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

Future<List<Vote>> fetchVotesByTaskId(int taskId) async {
  var headers = await addHeader();
  try {
    var response = await dio.get(
      '/votes/tasks/$taskId',
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['votes'] ?? [];

      return data.map((vote) => Vote.fromJson(vote)).toList();
    } else {
      throw Exception('Failed to load votes for task with id $taskId');
    }
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to fetch votes for task with id $taskId');
  }
}

Future<dynamic> updateVote(int voteId, int value) async {
  var headers = await addHeader();

  try {
    var response = await dio.put('/votes/$voteId',
        options: Options(headers: headers), data: {'value': value});
    return {
      'statusCode': response.statusCode,
      'data': response.data,
    };
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');

    throw Exception('Failed to update vote with id : $voteId');
  }
}
