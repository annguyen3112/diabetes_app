import 'package:flutter/material.dart';
import 'package:diabetes_app/providers/chat_provider.dart';

class AskScreen extends StatefulWidget {
  @override
  _AskScreenState createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final ChatGPTService _chatGPTService = ChatGPTService();
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': message});
      _isLoading = true;
    });

    _controller.clear();

    try {
      // Get chatbot response from OpenAI
      final response = await _chatGPTService.sendMessage(message);
      setState(() {
        messages.add({'sender': 'chatbot', 'text': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        messages.add({
          'sender': 'chatbot',
          'text': 'Xin lỗi, đã có lỗi xảy ra khi liên lạc với chatbot.'
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỏi đáp với ChatGPT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập câu hỏi của bạn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
