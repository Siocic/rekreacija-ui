import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:rekreacija_mobile/models/user_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HallMessageScreen extends StatefulWidget {
  final String userId; // recipient user ID (hall owner's GUID)
  final String hallName; // hall's display name

  const HallMessageScreen({
    super.key,
    required this.userId,
    required this.hallName,
  });

  @override
  State<HallMessageScreen> createState() => _HallMessageScreenState();
}

class _HallMessageScreenState extends State<HallMessageScreen> {
  _HallMessageScreenState() {}
  HubConnection? _hubConnection;
  UserModel? _currentUser;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _connecting = true;

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
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = await authProvider.getUserProfile();
      setState(() => _currentUser = user);
      await _connectSignalR();
      await _loadMessageHistory();
    } finally {
      setState(() => _connecting = false);
    }
  }

  Future<void> _connectSignalR() async {
    final storage = const FlutterSecureStorage();
    String? jwt = await storage.read(key: 'jwt_token');
    if (jwt == null) {
      return;
    }

    try {
      final payload = JwtDecoder.decode(jwt);
    } catch (e) {
      print("Failed to decode JWT: $e");
    }

    final senderId = await getUserId(); // GUID string!
    if (senderId.isEmpty || senderId == ' ') {
      print("DEBUG: Could not get senderId from JWT.");
      return;
    }

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          "http://10.0.2.2:5246/chat?userId=$senderId",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => jwt,
          ),
        )
        .build();

    _hubConnection!.on("ReceiveMessage", (args) {
      final msg = args?.first;
      print("📥 Received: $msg");
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
      print("Failed to connect: $e");
    }
  }

  Future<void> _loadMessageHistory() async {
    final senderId = await getUserId(); // GUID string!
    final recipientId = widget.userId;
    if (senderId.isEmpty || senderId == ' ' || recipientId.isEmpty) {
      print("DEBUG: Could not get senderId or recipientId.");
      return;
    }
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse("http://10.0.2.2:5246/Chat/$senderId/$recipientId"),
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
    } else {
      print("Failed to load message history");
    }
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    final senderId = await getUserId(); // GUID string!
    final recipientId = widget.userId;

    if (content.isEmpty || senderId.isEmpty || recipientId.isEmpty) return;

    if (_hubConnection == null ||
        _hubConnection!.state != HubConnectionState.Connected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not connected to chat server!')),
      );
      return;
    }

    try {
      await _hubConnection!
          .invoke("SendMessage", args: [senderId, recipientId, content]);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  bool _hasCheckedToken = false;

  @override
  Widget build(BuildContext context) {
  if (!_hasCheckedToken) {
      _hasCheckedToken = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool isExpired = await isTokenExpired();
        if (isExpired) {
          showTokenExpiredDialog(context);
          return;
        }
      });
    }


    final userId = _currentUser?.id;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Message'),
      body: _connecting
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: customDecoration,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("To : ",
                          style: GoogleFonts.suezOne(
                              color: Colors.white, fontSize: 17)),
                      const SizedBox(width: 5),
                      Text(widget.hallName,
                          style: GoogleFonts.suezOne(
                              color: Colors.white, fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.green : Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(msg["content"],
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your message",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: ()async{

                      bool isExpired = await isTokenExpired();
                      if(isExpired)
                      {
                          showTokenExpiredDialog(context);
                          return;
                      }
                      else{
                        await _sendMessage();
                      }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(16.0)),
                      ),
                      child: const Text("Send Message",
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
