import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:front/colocation/Colocation.dart';
import 'package:front/dio/dio.dart';

Future<List<Colocation>> fetchColocations() async {
  try {
    var response = await dio.get('/colocations/user/1');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['colocations'];

      return data.map((coloc) => Colocation.fromJson(coloc)).toList();
    } else {
      throw Exception('Failed to load colocations 8');
    }
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to load colocations');
  }
}
