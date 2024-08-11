import 'package:flutter/material.dart';
import 'package:diabetes_app/models/lesson.dart';
import 'package:diabetes_app/database.dart';

class LessonScreen extends StatefulWidget {
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
        title: Text('Lịch trình của tôi'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
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
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No lessons available'));
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
