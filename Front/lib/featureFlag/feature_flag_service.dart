import 'package:dio/dio.dart';
import 'package:front/featureFlag/featureFlag.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

const String _endpoint = '/backend/fp';

Future<List<FeatureFlag>> fetchFeatureFlags() async {
  var headers = await addHeader();
  try {
    var response = await dio.get(_endpoint, options: Options(headers: headers));
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((flag) => FeatureFlag.fromJson(flag)).toList();
    } else {
      throw Exception('Failed to load feature flags');
    }
  } on DioException catch (e) {
    print('Dio error! $e');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    throw Exception('Failed to load feature flags');
  }
}

Future<void> updateFeatureFlag(FeatureFlag flag) async {
  var headers = await addHeader();
  try {
    var response = await dio.put(
      '$_endpoint/${flag.id}',
      data: flag.toJson(),
      options: Options(headers: headers),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update feature flag');
    }
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    print('Feature Flag ID: ${flag.id}');
    print('Feature Flag Data: ${flag.toJson()}');
    throw Exception('Failed to update feature flag');
  }
}
