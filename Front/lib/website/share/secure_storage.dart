import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await _storage.write(key: 'token', value: token);
}

Future<String?> getToken() async {
  return await _storage.read(key: 'token');
}

Future<Map<String, dynamic>> addHeader() async {
  String? token = await getToken();
  Map<String, dynamic> headers = {};
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}

Future<void> deleteToken() async {
  await _storage.delete(key: 'token');
}

Future<Map<String, dynamic>> decodeToken() async {
  var token = await getToken() ?? '';
  try {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken;
  } catch (e) {
    print('Failed to decode token: $e');
    throw Exception('Failed to decode token');
  }
}
