import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:colibris/utils/dio.dart';

class LogService {
  final Dio _dio = dio;

  Future<List<Log>> fetchLogs() async {
    try {
      final response = await _dio.get('/backend/logs');

      if (response.statusCode == 200) {
        List<Log> logs =
            (response.data as List).map((log) => Log.fromJson(log)).toList();
        return logs;
      } else {
        throw Exception('Failed to load logs');
      }
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      log('Dio error!');
      log('Response status: ${e.response?.statusCode}');
      log('Response data: ${e.response?.data}');
      throw Exception('Failed to load logs');
    }
  }
}

class Log {
  final int id;
  final String method;
  final String path;
  final String clientIp;
  final String date;
  final String time;
  final String level;
  final int status;

  Log({
    required this.id,
    required this.method,
    required this.path,
    required this.clientIp,
    required this.date,
    required this.time,
    required this.level,
    required this.status,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['ID'] ?? 0,
      method: json['Method'] ?? '',
      path: json['Path'] ?? '',
      clientIp: json['ClientIP'] ?? '',
      date: json['Date'] ?? '',
      time: json['Time'] ?? '',
      level: json['Level'] ?? '',
      status: json['Status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Level': level,
      'Method': method,
      'Path': path,
      'ClientIp': clientIp,
      'Date': date,
      'Status': status,
      'Time': time,
    };
  }
}
