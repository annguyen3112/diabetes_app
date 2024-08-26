import 'package:diabetes_app/database.dart';
import 'package:flutter/material.dart';
import 'enter_blood_sugar_screen.dart';

class BloodSugarScreen extends StatefulWidget {
  final int userId;

  BloodSugarScreen({required this.userId});

  @override
  _BloodSugarScreenState createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  Map<String, dynamic>? _latestBloodSugarData;

  @override
  void initState() {
    super.initState();
    _fetchLatestBloodSugar();
  }

  Future<void> _fetchLatestBloodSugar() async {
    final latestData = await _getLatestBloodSugar(widget.userId);
    setState(() {
      _latestBloodSugarData = latestData;
    });
  }

  Future<Map<String, dynamic>?> _getLatestBloodSugar(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getLatestBloodSugar(userId);
  }

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
                  // Latest Blood Sugar (Gần nhất)
                  if (_latestBloodSugarData != null)
                    _buildLatestCard(context, _latestBloodSugarData!)
                  else
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _getLatestBloodSugar(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return _buildEmptyLatestCard(context);
                        } else {
                          final data = snapshot.data!;
                          return _buildLatestCard(context, data);
                        }
                      },
                    ),
                  SizedBox(height: 16),
                  // Distribution Frequency (Tần suất phân bố)
                  _buildDistributionCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnterBloodSugarScreen(userId: widget.userId),
            ),
          );
          if (result != null) {
            setState(() {
              _latestBloodSugarData = result;
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildEmptyLatestCard(BuildContext context) {
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
            Text('Gần nhất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Chưa có dữ liệu chỉ số đường huyết. Vui lòng nhập để theo dõi tình trạng bệnh.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterBloodSugarScreen(userId: widget.userId),
                  ),
                );
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

  Widget _buildLatestCard(BuildContext context, Map<String, dynamic> data) {
    final double level = data['level'];  // Get the blood sugar level
    String statusText;
    Color textColor;
    Color backgroundColor;

    if (level <= 55) {
      statusText = 'Rất thấp';
      textColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (level <= 70) {
      statusText = 'Thấp';
      textColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else if (level <= 130) {
      statusText = 'Tốt';
      textColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (level <= 250) {
      statusText = 'Cao';
      textColor = Colors.red;
      backgroundColor = Colors.red.shade100;
    } else {
      statusText = 'Rất cao';
      textColor = Colors.red.shade900;
      backgroundColor = Colors.red.shade100;
    }

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
            Text('Gần nhất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${level} mg/dL',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('${data['time']}, ${data['moment']}', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(BuildContext context) {
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
            Text('Tần suất phân bố', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            // Replace with actual distribution chart
            Container(
              height: 150,
              color: Colors.grey.shade200,
              child: Center(child: Text('Biểu đồ phân bố')),
            ),
          ],
        ),
      ),
    );
  }
}
