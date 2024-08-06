import 'package:flutter/material.dart';

class BloodSugarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đường huyết'),
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
              '12 tháng 12 năm 2023',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodSugarCard('Cao', '260 mg/dL', '12:15, Sau ăn trưa', Colors.red, reason: 'Tôi có ăn chè thái chung với bữa trưa'),
            SizedBox(height: 20),
            Text(
              '10 tháng 12 năm 2023',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodSugarCard('Tốt', '89 mg/dL', '11:20, Trước ăn trưa', Colors.green),
            SizedBox(height: 20),
            Text(
              '10 tháng 12 năm 2023',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBloodSugarCard('Thấp', '68 mg/dL', '11:20, Trước ăn trưa', Colors.orange),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new blood sugar record logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBloodSugarCard(String status, String sugar, String time, Color color, {String? reason}) {
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
            Text(sugar),
            Text(time),
            if (reason != null) Text('Lý do: $reason', style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
