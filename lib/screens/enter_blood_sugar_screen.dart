import 'package:flutter/material.dart';

class EnterBloodSugarScreen extends StatefulWidget {
  @override
  _EnterBloodSugarScreenState createState() => _EnterBloodSugarScreenState();
}

class _EnterBloodSugarScreenState extends State<EnterBloodSugarScreen> {
  double _bloodSugar = 0.0;
  bool _isEditing = false;

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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: _isEditing
                          ? TextField(
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            _bloodSugar = double.tryParse(value) ?? _bloodSugar;
                          });
                        },
                        onSubmitted: (_) {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        decoration: InputDecoration(
                          suffixText: 'mg/dL',
                          suffixStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                          ),
                        ),
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _bloodSugar.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'mg/dL',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildBloodSugarLabel(),
                    SizedBox(height: 8),
                    _buildBloodSugarLevelBar(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Timestamp and Meal Info Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10:39 - 14/08/2024'),
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
            // Warning Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lưu ý: Thông tin về chỉ số đường huyết chỉ mang tính chất tham khảo. '
                            'Vui lòng tham khảo ý kiến của bác sĩ để có lời khuyên cụ thể.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
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

  Widget _buildBloodSugarLabel() {
    String statusText;
    Color statusColor;

    if (_bloodSugar < 55) {
      statusText = 'rất thấp';
      statusColor = Colors.orange;
    } else if (_bloodSugar >= 55 && _bloodSugar <= 70) {
      statusText = 'thấp';
      statusColor = Colors.yellow;
    } else if (_bloodSugar >= 71 && _bloodSugar <= 130) {
      statusText = 'tốt';
      statusColor = Colors.green;
    } else if (_bloodSugar >= 131 && _bloodSugar <= 250) {
      statusText = 'cao';
      statusColor = Colors.red;
    } else {
      statusText = 'rất cao';
      statusColor = Colors.red[900]!;
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Mức đường huyết của bạn ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          TextSpan(
            text: statusText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodSugarLevelBar() {
    Color barColor;
    if (_bloodSugar < 55) {
      barColor = Colors.orange;
    } else if (_bloodSugar >= 55 && _bloodSugar <= 70) {
      barColor = Colors.yellow;
    } else if (_bloodSugar >= 71 && _bloodSugar <= 130) {
      barColor = Colors.green;
    } else if (_bloodSugar >= 131 && _bloodSugar <= 250) {
      barColor = Colors.red;
    } else {
      barColor = Colors.red[900]!;
    }

    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
