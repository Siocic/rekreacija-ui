import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:signalr_netcore/signalr_client.dart';

class MessageThreadScreen extends StatefulWidget {
  final String userId; // Hall owner's user ID
  final String hallName;

  const MessageThreadScreen({
    super.key,
    required this.userId,
    required this.hallName,
  });

  @override
  State<MessageThreadScreen> createState() =>
      _MessageThreadScreenState();
}

class _MessageThreadScreenState
    extends State<MessageThreadScreen> {
  HubConnection? _hubConnection;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _connecting = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _hubConnection?.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final userId = await getUserId();
    setState(() => _currentUserId = userId);
    await _connectSignalR(userId);
    await _loadMessageHistory(userId);
    setState(() => _connecting = false);
  }

  Future<void> _connectSignalR(String senderId) async {
    final jwt = await getJwtToken();
    if (jwt == null || jwt.isEmpty) return;

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://localhost:5246/chat?userId=$senderId",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => jwt,
          ),
        )
        .build();

    _hubConnection!.on("ReceiveMessage", (args) {
      final msg = args?.first;
      if (msg is Map) {
        setState(() {
          _messages.add({
            "senderId": msg["senderId"],
            "content": msg["content"],
          });
        });
      }
    });

    try {
      await _hubConnection!.start();
      await _hubConnection!.invoke("RegisterUser", args: [senderId]);
    } catch (e) {
      // handle connection error
    }
  }

  Future<void> _loadMessageHistory(String senderId) async {
    final recipientId = widget.userId;
    final headers = await getAuthHeaders();
    final response = await http.get(
      Uri.parse("http://localhost:5246/chat/$senderId/$recipientId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _messages = data
            .map((e) => {
                  "senderId": e["senderId"],
                  "content": e["content"],
                })
            .toList();
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    final senderId = _currentUserId;
    final recipientId = widget.userId;

    if (content.isEmpty ||
        senderId == null ||
        recipientId.isEmpty ||
        _hubConnection?.state != HubConnectionState.Connected) return;

    try {
      await _hubConnection!.invoke("SendMessage", args: [senderId, recipientId, content]);
      _controller.clear();
    } catch (e) {
      // handle send error
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.hallName}"),
        centerTitle: true,
        backgroundColor: Colors.teal.shade800,
      ),
      body: _connecting
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final msg = _messages[i];
                      final isMe = msg["senderId"] == userId;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg["content"] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                        ),
                        child: const Text("Send"),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
