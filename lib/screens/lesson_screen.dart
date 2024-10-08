import 'package:flutter/material.dart';
import 'package:diabetes_app/models/lesson.dart';
import 'package:diabetes_app/database.dart';

import 'chatbot_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<List<Lesson>> lessons;

  @override
  void initState() {
    super.initState();
    lessons = DatabaseHelper.instance.getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch trình của tôi'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryButton('Lộ trình'),
                _buildCategoryButton('Gợi ý'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Lesson>>(
              future: lessons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No lessons available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Lesson lesson = snapshot.data![index];
                      return ListTile(
                        leading: Image.asset(lesson.image),
                        title: Text(lesson.title),
                        subtitle: Text(lesson.category),
                        trailing: Text(lesson.description),
                        onTap: () {
                          // Handle lesson tap
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          }
          // if (index == 0) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ()),
          //   );
          // }
          // if (index == 3) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ()),
          //   );
          // }
        },
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return ElevatedButton(
      onPressed: () {
        // Handle category button tap
      },
      child: Text(title),
    );
  }
}
