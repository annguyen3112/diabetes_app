import 'package:flutter/material.dart';
import 'chatbot_screen.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Xử lý khi nhấn vào biểu tượng thông báo
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nguyễn Văn An',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Thành viên',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCard('Đường huyết', 'Hôm qua', '211.6 mg/dL', Icons.sentiment_very_dissatisfied, Colors.red),
                  _buildCard('Huyết áp', 'Hôm qua', '140/80 mmHg', Icons.sentiment_dissatisfied, Colors.orange),
                  _buildCard('Vận động', 'Hôm qua', '1632 kcal', Icons.local_fire_department, Colors.green),
                  _buildCard('Dinh dưỡng', 'Hôm qua', '1500 kcal', Icons.restaurant, Colors.green),
                  _buildCard('Cân nặng', '28/07', '68 kg', Icons.fitness_center, Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Bài học'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Hỏi đáp'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatbotScreen()),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LessonScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
            Spacer(),
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Expanded(child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
