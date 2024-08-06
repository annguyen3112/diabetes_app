import 'package:flutter/material.dart';

class BloodPressureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Huyết áp'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter logic here
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
            Text(
              'Hôm nay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodPressureCard('Bình thường', '120/80 mmHg', '78 lần/phút', '18:30, Trước ăn tối', Colors.green),
            SizedBox(height: 20),
            Text(
              '14 tháng 12 năm 2023',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodPressureCard('Thấp', '89/60 mmHg', '68 lần/phút', '18:20, Trước ăn tối', Colors.orange),
            SizedBox(height: 20),
            Text(
              '10 tháng 12 năm 2023',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodPressureCard('Tăng huyết áp độ 1', '140/90 mmHg', '100 lần/phút', '17:30, Trước ăn tối', Colors.red, reason: 'Không rõ'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new blood pressure record logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBloodPressureCard(String status, String bp, String pulse, String time, Color color, {String? reason}) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(status.substring(0, 1), style: TextStyle(color: Colors.white)),
        ),
        title: Text(status),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$bp • $pulse'),
            Text(time),
            if (reason != null) Text('Lý do: $reason', style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
