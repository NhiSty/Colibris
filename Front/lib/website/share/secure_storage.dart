import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
