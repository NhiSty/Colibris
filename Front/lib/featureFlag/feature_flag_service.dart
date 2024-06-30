import 'package:dio/dio.dart';
import 'package:front/featureFlag/FeatureFlag.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

Future<List<FeatureFlag>> fetchFeatureFlags() async {
  var headers = await addHeader();
  try {
    var response =
        await dio.get('/backend/fp', options: Options(headers: headers));
    if (response.statusCode == 200) {
     
      List<dynamic> data = response.data;
      return data.map((flag) => FeatureFlag.fromJson(flag)).toList();
    } else {
      throw Exception('Failed to load feature flags');
    }
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    throw Exception('Failed to load feature flags');
  }
}
