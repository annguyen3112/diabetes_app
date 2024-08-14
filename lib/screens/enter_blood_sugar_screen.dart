import 'package:flutter/material.dart';

class EnterBloodSugarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập chỉ số đường huyết'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Blood Sugar Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('0.0', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    // Add more widgets here for the slider and time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10:51 - 13/08/2024'),
                        TextButton(onPressed: () {}, child: Text('Chỉnh sửa')),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trước ăn trưa'),
                        TextButton(onPressed: () {}, child: Text('Chỉnh sửa')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Notes Section
            TextField(
              decoration: InputDecoration(
                labelText: 'Nhập ghi chú của bạn',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // Add Image Section
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add_a_photo),
              label: Text('Thêm ảnh'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            Spacer(),
            // Save Button
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              child: Text('Lưu'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
