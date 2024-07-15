import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:colibris/chat/models/message.dart';
import 'package:colibris/chat/services/api_service.dart';
import 'package:colibris/website/share/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessagesHandlePage extends StatefulWidget {
  final int colocationId;

  const MessagesHandlePage({super.key, required this.colocationId});

  static const routeName = "/backoffice/colocations/messages";

  @override
  _MessagesHandlePageState createState() => _MessagesHandlePageState();
}

class _MessagesHandlePageState extends State<MessagesHandlePage> {
  late WebSocketChannel _channel;
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  late int _userId;
  int? _hoveredMessageIndex;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getUserData();
    await _fetchMessages();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _channel.sink.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    var userData = await decodeToken();
    setState(() {
      _userId = userData['user_id'];
    });
  }

  Future<void> _fetchMessages() async {
    try {
      List<Message> messages =
          await apiService.getMessages(widget.colocationId);
      setState(() {
        _messages = messages;
        _scrollToBottom();
      });
    } catch (e) {
      print('Failed to load messages: $e');
    }
  }

  void _connectToWebSocket() async {
    try {
      var token = await getToken() ?? '';
      var url = '';

      if (dotenv.env['ENVIRONMENT'] == 'prod') {
        url =
            'wss://back.colibris.live/api/v1/chat/colocations/${widget.colocationId}/admin/ws?token=$token';
      } else {
        url =
            'ws://localhost:8080/api/v1/chat/colocations/${widget.colocationId}/admin/ws?token=$token';
      }

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel.stream.listen((message) {
        try {
          final data = json.decode(message);
          if (data["type"] == "delete") {
            final messageId = data["messageID"];
            setState(() {
              _messages.removeWhere((msg) => msg.id == messageId);
            });
          } else {
            final newMessage = Message.fromJson(data);
            setState(() {
              _messages.add(newMessage);
              _scrollToBottom();
            });
          }
        } catch (e) {
          print("WebSocket message error: $e");
        }
      }, onError: (error) {
        print("WebSocket error: $error");
      }, onDone: () {
        print("WebSocket closed");
      });
    } catch (e) {
      print("WebSocket connection error: $e");
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = json.encode({
        "type": "message",
        "content": _messageController.text,
      });
      _channel.sink.add(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteMessage(int index) {
    final message = _messages[index];
    final deleteCommand = json.encode({
      "type": "delete",
      "messageID": message.id,
    });
    _channel.sink.add(deleteCommand);
    setState(() {
      _messages.removeAt(index);
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0 && now.day == timestamp.day) {
      return 'Today, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays == 1 && now.day - timestamp.day == 1) {
      return 'Yesterday, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE, HH:mm').format(timestamp)}';
    } else {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(timestamp)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat_title'.tr())),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.senderId == _userId;
                final showDateSeparator = index == 0 ||
                    _messages[index - 1].createdAt.day != message.createdAt.day;

                return MouseRegion(
                  onEnter: (_) => setState(() {
                    _hoveredMessageIndex = index;
                  }),
                  onExit: (_) => setState(() {
                    _hoveredMessageIndex = null;
                  }),
                  child: Column(
                    children: [
                      if (showDateSeparator)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            DateFormat('dd MMM yyyy').format(message.createdAt),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: isUserMessage
                                  ? Radius.circular(8)
                                  : Radius.zero,
                              bottomRight: isUserMessage
                                  ? Radius.zero
                                  : Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.senderName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      message.content,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 3),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        _formatTimestamp(
                                            message.createdAt.toLocal()),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_hoveredMessageIndex == index)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteMessage(index),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        InputDecoration(hintText: 'chat_enter_message'.tr()),
                    onTap: _scrollToBottom,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
