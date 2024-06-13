import 'package:dio/dio.dart';
import 'package:front/ColocMembers/colocMembers.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

Future<List<ColocMembers>> fetchColoMembersByColoc(int colocId) async {
  var headers = await addHeader();
  var userData = await decodeToken();
  try {
    final response = await dio.get('/coloc/members/colocation/$colocId',
        options: Options(headers: headers));
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['colocMembers'] ?? [];
      data.removeWhere((element) => element['UserID'] == userData['user_id']);
      return data.map((coloc) => ColocMembers.fromJson(coloc)).toList();
    }
    return [];
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    throw Exception('Failed to load colocations');
  }
}

Future<int> deleteColocMember(int colocMemberId) async {
  var headers = await addHeader();
  try {
    var response = await dio.delete(
      '/coloc/members/$colocMemberId',
      options: Options(headers: headers),
    );
    return response.statusCode!;
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    return e.response!.statusCode ?? 500;
  }
}
