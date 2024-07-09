import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:front/utils/dio.dart';
import 'package:front/invitation/invitation.dart';
import 'package:front/website/share/secure_storage.dart';

Future<List<Invitation>> fetchInvitations() async {
  var headers = await addHeader();
  try {
    var userData = await decodeToken();

    var response = await dio.get('/invitations/user/${userData['user_id']}',
        options: Options(headers: headers));
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['result'];
      return data.map((invit) => Invitation.fromJson(invit)).toList();
    } else {
      throw Exception('Failed to load invitations 8');
    }
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to load invitations');
  }
}

Future<dynamic> createInvitation(String email, int colocId) async {
  var headers = await addHeader();
  try {
    var response = await dio.post(
      '/invitations',
      data: {
        'email': email,
        'colocationId': colocId,
      },
      options: Options(headers: headers),
    );
    return response;
  } on DioException catch (e) {
    print('Dio error!');
    print('Response status: ${e.response!.statusCode}');
    print('Response data: ${e.response!.data}');
    return e.response!.statusCode ?? 500;
  }
}

Future<int> updateInvitation(int invitId, String state) async {
  var headers = await addHeader();
  try {
    var response = await dio.patch(
      '/invitations',
      data: {
        'state': state,
        'invitationId': invitId,
      },
      options: Options(headers: headers),
    );
    print(response.data);
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}
