import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:colibris/colocation/colocation.dart';
import 'package:colibris/utils/dio.dart';
import 'package:colibris/website/share/secure_storage.dart';

class ColocationService {
  final Dio _dio = dio;

  Future<ColocationResponse> getAllColocations(
      {int page = 1, int pageSize = 5}) async {
    var headers = await addHeader();
    try {
      final response = await _dio.get(
        '/colocations',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<Colocation> colocations = (response.data['colocations'] as List)
            .map((colocation) => Colocation.fromJson(colocation))
            .toList();
        int total = response.data['total'];
        return ColocationResponse(colocations: colocations, total: total);
      } else {
        throw Exception('Failed to load colocations');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to load colocations');
    }
  }

  Future<List<Colocation>> searchColocations({required String query}) async {
    var headers = await addHeader();
    try {
      final response = await _dio.get(
        '/colocations/search',
        queryParameters: {
          'query': query,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        List<Colocation> colocations = (response.data as List)
            .map((colocation) => Colocation.fromJson(colocation))
            .toList();
        return colocations;
      } else {
        throw Exception('Failed to search colocations');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to search colocations');
    }
  }

  Future<void> createColocation({
    required String name,
    required String description,
    required bool isPermanent,
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    var headers = await addHeader();
    var userData = await decodeToken();

    try {
      final response = await _dio.post(
        '/colocations',
        data: {
          'name': name,
          "userId": userData['user_id'],
          'description': description,
          'isPermanent': isPermanent,
          'latitude': latitude,
          'longitude': longitude,
          'location': location,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create colocation');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to create colocation');
    }
  }

  Future<void> updateColocation(
      int colocationId, Map<String, dynamic> colocationUpdates) async {
    var headers = await addHeader();
    try {
      final response = await _dio.patch(
        '/colocations/$colocationId',
        data: colocationUpdates,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        log('Colocation updated successfully');
      } else {
        throw Exception('Failed to update colocation');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to update colocation');
    }
  }

  Future<void> deleteColocation(int colocationId) async {
    var headers = await addHeader();
    try {
      final response = await _dio.delete(
        '/colocations/$colocationId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        log('Colocation deleted successfully');
      } else {
        throw Exception('Failed to delete colocation');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to delete colocation');
    }
  }

  Future<Map<String, dynamic>> getColocationById(int colocationId) async {
    var headers = await addHeader();
    try {
      print('Fetching colocation data...');
      final response = await _dio.get(
        '/colocations/$colocationId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load colocation data');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Dio error!');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Exception('Failed to load colocation data');
    }
  }
}

class ColocationResponse {
  final List<Colocation> colocations;
  final int total;

  ColocationResponse({required this.colocations, required this.total});
}
