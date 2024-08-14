import 'package:flutter/material.dart';
import 'enter_blood_sugar_screen.dart';

class BloodSugarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đường huyết'),
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
            // Title and Options
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
            // Tab Bar
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
            // Content Area
            Expanded(
              child: ListView(
                children: [
                  // Distribution Frequency
                  _buildCard(
                    context: context,
                    title: 'Tần suất phân bố',
                    content: 'Chưa có dữ liệu chỉ số đường huyết. Vui lòng nhập để theo dõi tình trạng bệnh.',
                  ),
                  SizedBox(height: 16),
                  // Blood Sugar Trend
                  _buildCard(
                    context: context,
                    title: 'Xu hướng đường huyết',
                    content: 'Chưa có dữ liệu chỉ số đường huyết. Vui lòng nhập để theo dõi tình trạng bệnh.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add blood sugar entry
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildCard({required BuildContext context, required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(content, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => EnterBloodSugarScreen()));
              },
              icon: Icon(Icons.add),
              label: Text('Nhập chỉ số'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
