import 'package:diabetes_app/screens/blood_pressure_screen.dart';
import 'package:flutter/material.dart';
import 'chatbot_screen.dart';
import 'lesson_screen.dart';
import 'blood_sugar_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final int userId;

  HomeScreen({required this.userName, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sức khỏe tiểu đường'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info Header
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
                      userName,
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
            // Grid View
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildCard(context, 'Đường huyết', Icons.monitor_heart_outlined, 'BloodSugarScreen'),
                  _buildCard(context, 'Huyết áp', Icons.favorite_border, 'BloodPressureScreen'),
                  _buildCard(context, 'Dinh dưỡng', Icons.restaurant_menu, ''),
                  _buildCard(context, 'Vận động', Icons.directions_run, ''),
                  _buildCard(context, 'Cân nặng', Icons.fitness_center, ''),
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
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Hỏi đáp'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cài đặt'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
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
          // if (index == 3) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => SettingsScreen()),
          //   );
          // }
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String screen) {
    return InkWell(
      onTap: () {
        if (screen == 'BloodSugarScreen') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BloodSugarScreen(userId: userId)),
          );
        } if (screen == 'BloodPressureScreen') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BloodPressureScreen(userId: userId)),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.teal),
              Spacer(),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

}
