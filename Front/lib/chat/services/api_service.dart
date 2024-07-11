import 'package:dio/dio.dart';
import 'package:front/chat/models/message.dart';
import 'package:front/utils/dio.dart';
import 'package:front/website/share/secure_storage.dart';

class ApiService {
  Future<List<Message>> getMessages(int conversationId) async {
    var headers = await addHeader();
    try {
      final response = await dio.get(
          '/chat/colocations/$conversationId/messages',
          options: Options(headers: headers));
      List<dynamic> data = response.data;

      return data.map((item) => Message.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }
}
