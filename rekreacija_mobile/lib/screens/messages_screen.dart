import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/screens/hall_message_screen.dart'; // <-- add this import

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> _conversations = [];
  String? _userId;
  static String? baseUrl = String.fromEnvironment("BASE_URL",defaultValue:"http://10.0.2.2:5246/");


  @override
  void initState() {
    super.initState();
    _loadUserIdAndConversations();
  }

  Future<void> _loadUserIdAndConversations() async {
    final userId = await getUserId();

    setState(() => _userId = userId);
    final url = "http://10.0.2.2:7271/chat/conversations/$userId";
    //final url = "${baseUrl}chat/conversations/$userId";
    try {
      final headers = await getAuthHeaders();

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() => _conversations = data);
      } else {
        print("❌ ERROR: Failed to load conversations (${response.statusCode})");
      }
    } catch (e) {
      print("❌ ERROR: Exception while fetching conversations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations', style: GoogleFonts.ultra(fontSize: 22)),
        backgroundColor: const Color.fromARGB(225, 29, 29, 29),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF1E1E1E),
        child: _conversations.isEmpty
            ? const Center(
                child: Text("No conversations found",
                    style: TextStyle(color: Colors.white)),
              )
            : ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final convo = _conversations[index];
                  final hallName = convo['hallName'] ?? 'Unknown';
                  final lastMessage = convo['lastMessage'] ?? '';
                  final timestamp = convo['lastTimestamp'] ?? '';
                  final conversationUserId = convo['conversationUserId'];

                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(hallName,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(lastMessage,
                          style: const TextStyle(color: Colors.white70)),
                      trailing: Text(
                        timestamp
                            .toString()
                            .substring(0, 16)
                            .replaceAll('T', ' '),
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HallMessageScreen(
                              userId: conversationUserId,
                              hallName: hallName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
