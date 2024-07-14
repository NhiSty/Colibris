import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static WebSocketChannel connect(int conversationId, String token) {
    var url = '';

    if (dotenv.env['ENVIRONMENT'] == 'prod') {
      url =
          'wss://back.colibris.live/api/v1/chat/colocations/$conversationId/ws/';
    } else {
      url = 'ws://10.0.2.2:8080/api/v1/chat/colocations/$conversationId/ws/';
    }

    final headers = {
      'Authorization': 'Bearer $token',
    };

    return IOWebSocketChannel.connect(
      url,
      headers: headers,
    );
  }
}
