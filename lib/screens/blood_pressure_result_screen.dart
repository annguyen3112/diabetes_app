import 'package:diabetes_app/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodPressureResultScreen extends StatefulWidget {
  final int userId;

  BloodPressureResultScreen({required this.userId});

  @override
  _BloodPressureResultScreenState createState() => _BloodPressureResultScreenState();
}

class _BloodPressureResultScreenState extends State<BloodPressureResultScreen> {
  Map<String, dynamic>? _latestBloodPressureData;
  double? _minSystolic;
  double? _avgSystolic;
  double? _maxSystolic;
  double? _minDiastolic;
  double? _avgDiastolic;
  double? _maxDiastolic;
  List<FlSpot> _systolicSpots = [];
  List<FlSpot> _diastolicSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchBloodPressureData();
    _fetchBloodPressureTrendData();
  }

  Future<void> _fetchBloodPressureData() async {
    final dbHelper = DatabaseHelper.instance;
    final latestData = await dbHelper.getLatestBloodPressure(widget.userId);
    final minSystolic = await dbHelper.getMinSystolicPressure(widget.userId);
    final avgSystolic = await dbHelper.getAverageSystolicPressure(widget.userId);
    final maxSystolic = await dbHelper.getMaxSystolicPressure(widget.userId);
    final minDiastolic = await dbHelper.getMinDiastolicPressure(widget.userId);
    final avgDiastolic = await dbHelper.getAverageDiastolicPressure(widget.userId);
    final maxDiastolic = await dbHelper.getMaxDiastolicPressure(widget.userId);

    setState(() {
      _latestBloodPressureData = latestData;
      _minSystolic = minSystolic;
      _avgSystolic = avgSystolic;
      _maxSystolic = maxSystolic;
      _minDiastolic = minDiastolic;
      _avgDiastolic = avgDiastolic;
      _maxDiastolic = maxDiastolic;
    });
  }

  Future<void> _fetchBloodPressureTrendData() async {
    final dbHelper = DatabaseHelper.instance;
    final bloodPressureData = await dbHelper.getBloodPressureData(widget.userId);

    List<FlSpot> systolicSpots = bloodPressureData.map<FlSpot>((data) {
      final date = DateTime.parse(data['date']);
      final dayOfMonth = date.day.toDouble();
      final systolic = data['systolic'] as double;
      return FlSpot(dayOfMonth, systolic);
    }).toList();

    List<FlSpot> diastolicSpots = bloodPressureData.map<FlSpot>((data) {
      final date = DateTime.parse(data['date']);
      final dayOfMonth = date.day.toDouble();
      final diastolic = data['diastolic'] as double;
      return FlSpot(dayOfMonth, diastolic);
    }).toList();

    setState(() {
      _systolicSpots = systolicSpots;
      _diastolicSpots = diastolicSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Huyết áp'),
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
            Expanded(
              child: ListView(
                children: [
                  if (_latestBloodPressureData != null)
                    _buildLatestCard(context, _latestBloodPressureData!)
                  else
                    FutureBuilder<Map<String, dynamic>?>(
                      future: DatabaseHelper.instance.getLatestBloodPressure(widget.userId),
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
                  _buildMinAvgMaxSection(),
                  SizedBox(height: 16),
                  //_buildTrendChart(),
                ],
              ),
            ),
          ],
        ),
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
            Text('Chưa có dữ liệu huyết áp. Vui lòng nhập để theo dõi tình trạng.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to blood pressure input screen
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
    final double systolic = data['systolic'];
    final double diastolic = data['diastolic'];
    String statusText;
    Color textColor;
    Color backgroundColor;

    // Determine the status based on blood pressure ranges
    if (systolic < 90 && diastolic < 60) {
      statusText = 'Thấp';
      textColor = Colors.orange;
      backgroundColor = Colors.orange.shade100;
    } else if (systolic <= 130 && diastolic <= 85) {
      statusText = 'Bình thường';
      textColor = Colors.green;
      backgroundColor = Colors.green.shade100;
    } else if (systolic <= 140 && diastolic <= 90) {
      statusText = 'Bình thường cao';
      textColor = Colors.yellow;
      backgroundColor = Colors.yellow.shade100;
    } else {
      statusText = 'Cao';
      textColor = Colors.red;
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
                  '${systolic}/$diastolic mmHg',
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

  Widget _buildMinAvgMaxSection() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMinAvgMaxCard('Thấp nhất', _minSystolic, _minDiastolic, Colors.orange),
                _buildMinAvgMaxCard('Trung bình', _avgSystolic, _avgDiastolic, Colors.green),
                _buildMinAvgMaxCard('Cao nhất', _maxSystolic, _maxDiastolic, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinAvgMaxCard(String title, double? systolic, double? diastolic, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        Text(
          systolic != null && diastolic != null
              ? '${systolic.toStringAsFixed(0)}/${diastolic.toStringAsFixed(0)} mmHg'
              : '--/-- mmHg',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  // Widget _buildTrendChart() {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16.0),
  //     ),
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Xu hướng huyết áp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //           SizedBox(height: 16),
  //           SizedBox(
  //             height: 200,
  //             child: LineChart(
  //               LineChartData(
  //                 lineBarsData: [
  //                   LineChartBarData(
  //                     spots: _systolicSpots,
  //                     isCurved: true,
  //                     colors: [Colors.red],
  //                     barWidth: 4,
  //                     dotData: FlDotData(show: true),
  //                   ),
  //                   LineChartBarData(
  //                     spots: _diastolicSpots,
  //                     isCurved: true,
  //                     colors: [Colors.blue],
  //                     barWidth: 4,
  //                     dotData: FlDotData(show: true),
  //                   ),
  //                 ],
  //                 gridData: FlGridData(show: true),
  //                 titlesData: FlTitlesData(
  //                   leftTitles: AxisTitles(
  //                     sideTitles: SideTitles(showTitles: true),
  //                   ),
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(showTitles: true),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
