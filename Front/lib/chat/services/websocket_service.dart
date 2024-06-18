import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  static WebSocketChannel connect(int conversationId, String token) {
    final url =
        'ws://10.0.2.2:8080/api/v1/chat/colocations/$conversationId/ws/';
    final headers = {
      'Authorization': 'Bearer $token',
    };

    return IOWebSocketChannel.connect(
      url,
      headers: headers,
    );
  }
}
