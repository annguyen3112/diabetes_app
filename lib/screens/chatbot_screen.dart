import 'package:flutter/material.dart';
import 'ask_screen.dart';  // Import the AskScreen here
import 'lesson_screen.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hỏi đáp cùng chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: const [true, false],
                  onPressed: (index) {
                    // Add logic for switching between "Của tôi" and "Tất cả"
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Của tôi'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Tất cả'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Xem theo chủ đề', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('Tất cả'),
                  _buildChip('Triệu chứng'),
                  _buildChip('Biến chứng'),
                  _buildChip('Cách điều trị'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(  // Wrap the Card with GestureDetector to capture the tap
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AskScreen()),  // Navigate to AskScreen
                );
              },
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset('assets/chatbot_image.png', width: 60),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Đặt câu hỏi cho chatbot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Bạn chưa đặt câu hỏi nào, đừng ngại đưa ra những thắc mắc nhé!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Image.asset('assets/question_image.png'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Bài học'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Hỏi đáp'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LessonScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.green.shade100,
      ),
    );
  }
}
