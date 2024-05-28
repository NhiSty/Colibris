import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:front/dio/dio.dart';
import 'package:front/notification/invitation.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/share/secure_storage.dart';

Future<List<Invitation>> fetchInvitations() async {
  var headers = await addHeader();
  try {
    var userData = await decodeToken();

    var response = await dio.get('/invitations/user/${userData['user_id']}',
        options: Options(headers: headers));
    if (response.statusCode == 200) {
      print(response.data);
      List<dynamic> data = response.data['result'];
      print(data);

      return data.map((invit) => Invitation.fromJson(invit)).toList();
    } else {
      throw Exception('Failed to load invitations 8');
    }
  } on DioException catch (e) {
    print("Error: ${e}");
    print('Error: ${e}');
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    throw Exception('Failed to load invitations');
  }
}

Future<int> createInvitation(String email, int colocId) async {
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
    print(response.data);
    return response.statusCode!;
  } on DioException catch (e) {
    log('Dio error!');
    log('Response status: ${e.response!.statusCode}');
    log('Response data: ${e.response!.data}');
    return e.response?.statusCode ?? 500;
  }
}

Future<int> updateInvitation(int invitId, String state) async {
  var headers = await addHeader();
  try {
    var response = await dio.patch(
      '/invitations/',
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
