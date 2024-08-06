import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  List<String> _messages = [];
  TextEditingController _messageController = TextEditingController();

  List<String> get messages => _messages;
  TextEditingController get messageController => _messageController;

  void sendMessage() async {
    final message = _messageController.text;
    if (message.isEmpty) return;

    _messages.add("You: $message");
    _messageController.clear();
    notifyListeners();

    // Gọi API chatbot
    final response = await http.post(
      Uri.parse('YOUR_CHATBOT_API_URL'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final botMessage = data['bot_response'];

      _messages.add("Bot: $botMessage");
      notifyListeners();
    } else {
      _messages.add("Bot: Sorry, I didn't understand that.");
      notifyListeners();
    }
  }
}
