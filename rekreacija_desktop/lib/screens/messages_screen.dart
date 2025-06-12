import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/screens/message_thread_screen.dart'; // You will create this

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<dynamic> _conversations = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndConversations();
  }

  Future<void> _loadUserIdAndConversations() async {
    final userId = await getUserId();
    setState(() => _userId = userId);

    final headers = await getAuthHeaders();
    final url = "http://localhost:5246/chat/conversations/$userId?hall=false";

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => _conversations = data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load conversations (${response.statusCode})')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Messages'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: _conversations.isEmpty
                ? const Center(child: Text("No conversations yet", style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final convo = _conversations[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(convo['hallName'] ?? 'Unknown',
                              style: GoogleFonts.suezOne(color: Colors.white)),
                          subtitle: Text(convo['lastMessage'] ?? '',
                              style: const TextStyle(color: Colors.white70)),
                          trailing: Text(
                            convo['lastTimestamp']
                                .toString()
                                .substring(0, 16)
                                .replaceAll('T', ' '),
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MessageThreadScreen(
                                userId: convo['conversationUserId'],
                                hallName: convo['hallName'],
                              ),
                            ));
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
