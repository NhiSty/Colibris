import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage _storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await _storage.write(key: 'token', value: token);
}

Future<String?> getToken() async {
  return await _storage.read(key: 'token');
}
