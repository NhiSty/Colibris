import 'package:flutter/material.dart';
import 'package:front/chat/models/message.dart';
import 'package:front/chat/services/api_service.dart';
import 'package:front/chat/services/websocket_service.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/share/secure_storage.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final int conversationId;

  ConversationScreen({required this.conversationId});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late WebSocketChannel _channel;
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  late int _userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchMessages();
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
    print("object $userData");
    setState(() {
      _userId = userData['user_id'];
    });
  }

  Future<void> _fetchMessages() async {
    try {
      List<Message> messages = await apiService.getMessages(widget.conversationId);
      setState(() {
        _messages = messages;
        _scrollToBottom();
      });
    } catch (e) {
      print('Failed to load messages: $e');
    }
  }

  Future<void> _connectToWebSocket() async {
    var token = await getToken() ?? '';
    _channel = WebSocketService.connect(widget.conversationId, token);
    _channel.stream.listen((message) {
      try {
        final data = json.decode(message);
        final newMessage = Message.fromJson(data);
        setState(() {
          _messages.add(newMessage);
          _scrollToBottom();
        });
      } catch (e) {
        print("WebSocket message error: $e");
      }
    }, onError: (error) {
      print("WebSocket error: $error");
    }, onDone: () {
      print("WebSocket closed");
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _channel.sink.add(_messageController.text);
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0 && now.day == timestamp.day) {
      return 'Today, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays == 1 && now.day - timestamp.day == 1) {
      return 'Yesterday, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat('EEEE, HH:mm').format(timestamp)}'; // Day of the week and time
    } else {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(timestamp)}'; // Date and time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversation')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message.senderId == _userId;
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _formatTimestamp(message.createdAt.toLocal()), // Convert to local time
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    decoration: InputDecoration(hintText: 'Enter a message'),
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
