import 'package:diabetes_app/database.dart';
import 'package:diabetes_app/screens/weight_screen.dart';
import 'package:flutter/material.dart';

class WeightResultScreen extends StatefulWidget {
  final int userId;

  WeightResultScreen({required this.userId});

  @override
  _WeightResultScreenState createState() => _WeightResultScreenState();
}

class _WeightResultScreenState extends State<WeightResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cân nặng'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Handle help icon press
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_heart_outlined, size: 30, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Gợi ý lịch đo',
                  style: TextStyle(fontSize: 16, color: Colors.teal),
                ),
                Spacer(),
                Text(
                  '30 ngày',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Icon(Icons.filter_alt, size: 20, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            DefaultTabController(
              length: 2,
              child: TabBar(
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Biểu đồ'),
                  Tab(text: 'Chi tiết'),
                ],
              ),
            ),
            SizedBox(height: 16),
            WeightTrendWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeightScreen(userId: widget.userId),
            ),
          );
          // if (result != null) {
          //   setState(() {
          //     _latestBloodSugarData = result;
          //     _fetchBloodSugarTrendData();
          //   });
          // }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget WeightTrendWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cân nặng',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Trọng lượng: 70 kg',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Câu trả lời: Đây là câu trả lời từ image analysis',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}