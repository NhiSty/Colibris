import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/chat/models/message.dart';
import 'package:front/chat/services/api_service.dart';
import 'package:front/chat/services/websocket_service.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/colocation/colocation_tasklist_screen.dart';
import 'package:front/main.dart';
import 'package:front/utils/firebase.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConversationScreen extends StatefulWidget {
  final int conversationId;
  final bool fromNotification;

  const ConversationScreen(
      {super.key, required this.conversationId, this.fromNotification = false});
  static const routeName = "/chat";

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
  FirebaseClient firebaseClient = FirebaseClient();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchMessages();
    _connectToWebSocket();
    final roomId = widget.conversationId;
    firebaseClient.subscribeToTopic("room_colocation_$roomId");
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
          await apiService.getMessages(widget.conversationId);
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
      return '${DateFormat('EEEE, HH:mm').format(timestamp)}';
    } else {
      return '${DateFormat('dd MMM yyyy, HH:mm').format(timestamp)}';
    }
  }

  _whichUserGradient(Message message) {
    if (message.senderName.contains('Admin (')) {
      return [Colors.red.withOpacity(1), Colors.red.withOpacity(0.6)];
    } else if (message.senderId == _userId) {
      return [Colors.blue[800]!, Colors.blue[400]!];
    } else {
      return [Colors.grey.withOpacity(0.9), Colors.grey.withOpacity(0.4)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: Text('chat_title'.tr()),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  var res = await fetchColocation(widget.conversationId);
                  var colocation = Colocation.fromJson(res);
                  if (widget.fromNotification) {
                    context.go(ColocationTasklistScreen.routeName,
                        extra: {"colocation": colocation});
                  }
                  context.pop();
                  /**/
                },
              )),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUserMessage = message.senderId == _userId;
                    final isAdminMessage = message.senderName.contains('Admin (');
                    final showDateSeparator = index == 0 ||
                        _messages[index - 1].createdAt.day !=
                            message.createdAt.day;

                    return Column(
                      children: [
                        if (showDateSeparator)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              DateFormat('dd MMM yyyy')
                                  .format(message.createdAt),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _whichUserGradient(message),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (isAdminMessage)
                                      Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        child: Icon(Icons.warning, color: Colors.yellow),
                                      ),
                                    Text(message.senderName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,

                                        )
                                    )
                                  ],
                                ),
                                SizedBox(height: 3),
                                Text(
                                  message.content,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 3),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    _formatTimestamp(
                                        message.createdAt.toLocal()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'chat_enter_message'.tr(),
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        onTap: _scrollToBottom,
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _sendMessage,
                      backgroundColor: Colors.blueGrey[800],
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
