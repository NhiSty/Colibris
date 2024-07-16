import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:front/user/user.dart';
import 'package:front/vote/vote.dart';

import '../utils/dio.dart';
import '../website/share/secure_storage.dart';

class VoteService {
  final Dio _dio = dio;

  Future<dynamic> addVote({
    required int taskId,
    required int value,
    int userId = -1,
}) async {
    var headers = await addHeader();
    try {
      var response = await _dio.post(
        '/votes',
        data: {
          'taskId': taskId,
          'value': value,
          'userId': userId,
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
      var response = await _dio.get(
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
      var response = await _dio.get(
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
      var response = await _dio.put('/votes/$voteId',
          options: Options(headers: headers), data: {'value': value});
      return {
        'statusCode': response.statusCode,
        'message': response.data['message'],
        'vote': Vote.fromJson(response.data['vote']),
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        print('response.data : ${e.response?.data}');
        return {
          'statusCode': 422,
          'message': e.response?.data,
          'vote': null
        };
      }

      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');

      throw Exception('Failed to update vote with id : $voteId');
    }
  }

  Future<dynamic> deleteVote(int voteId) async {
    var headers = await addHeader();

    try {
      var response = await _dio.delete('/votes/$voteId',
          options: Options(headers: headers));
      return {
        'statusCode': response.statusCode,
        'data': response.data,
      };
    } on DioException catch (e) {
      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');

      throw Exception('Failed to delete vote with id : $voteId');
    }
  }

  // Get User by task id
  Future<List<User>> fetchUserByTaskId(int taskId) async {
    var headers = await addHeader();
    try {
      var response = await _dio.get(
        '/users/tasks/$taskId',
        options: Options(headers: headers),
      );
      print('Response: ${response}');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['users'] ?? [];

        var r = data.map((user) => User.fromJson(user)).toList();
        print('Response: ${r}');

        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users $taskId');
      }
    } on DioException catch (e) {
      log('Dio error!');
      log('Response status: ${e.response!.statusCode}');
      log('Response data: ${e.response!.data}');
      throw Exception('Failed to fetch users by taskId $taskId');
    }
  }
}
