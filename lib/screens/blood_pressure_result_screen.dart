import 'package:diabetes_app/database.dart';
import 'package:diabetes_app/screens/blood_pressure_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodPressureResultScreen extends StatefulWidget {
  final int userId;

  const BloodPressureResultScreen({super.key, required this.userId});

  @override
  _BloodPressureResultScreenState createState() => _BloodPressureResultScreenState();
}

class _BloodPressureResultScreenState extends State<BloodPressureResultScreen> {
  Map<String, dynamic>? _latestBloodPressureData;
  List<Map<String, dynamic>> bloodPressureDataList = [];
  double? _minSystolic;
  double? _avgSystolic;
  double? _maxSystolic;
  double? _minDiastolic;
  double? _avgDiastolic;
  double? _maxDiastolic;
  double? _minHeartRate;
  double? _avgHeartRate;
  double? _maxHeartRate;
  List<FlSpot> _systolicSpots = [];
  List<FlSpot> _diastolicSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchBloodPressureData();
    _fetchBloodPressureTrendData();
    _getHeartRateData();
    //_getBloodPressureData();
  }

  Future<void> _getHeartRateData() async {
    final data = await DatabaseHelper.instance.getHeartRateData(widget.userId);
    if (data != null) {
      setState(() {
        _minHeartRate = data['minHeartRate'];
        _avgHeartRate = data['avgHeartRate'];
        _maxHeartRate = data['maxHeartRate'];
      });
    }
  }

  Future<void> _fetchBloodPressureData() async {
    final dbHelper = DatabaseHelper.instance;

    // Lấy dữ liệu từ cơ sở dữ liệu
    final data = await dbHelper.getBloodPressureData(widget.userId);

    setState(() {
      bloodPressureDataList = data;
      if (bloodPressureDataList.isNotEmpty) {
        _latestBloodPressureData = bloodPressureDataList.last;
      }
    });

    // Cập nhật các giá trị min, avg, max
    _minSystolic = await dbHelper.getMinSystolicPressure(widget.userId);
    _avgSystolic = await dbHelper.getAverageSystolicPressure(widget.userId);
    _maxSystolic = await dbHelper.getMaxSystolicPressure(widget.userId);
    _minDiastolic = await dbHelper.getMinDiastolicPressure(widget.userId);
    _avgDiastolic = await dbHelper.getAverageDiastolicPressure(widget.userId);
    _maxDiastolic = await dbHelper.getMaxDiastolicPressure(widget.userId);
  }

  Future<void> _fetchBloodPressureTrendData() async {
    final dbHelper = DatabaseHelper.instance;
    final bloodPressureData = await dbHelper.getBloodPressureData(widget.userId);

    List<FlSpot> systolicSpots = bloodPressureData.map<FlSpot>((data) {
      final date = DateTime.parse(data['date']);
      final dayOfMonth = date.day.toDouble();
      final systolic = (data['systolic'] as num).toDouble();
      return FlSpot(dayOfMonth, systolic);
    }).toList();

    List<FlSpot> diastolicSpots = bloodPressureData.map<FlSpot>((data) {
      final date = DateTime.parse(data['date']);
      final dayOfMonth = date.day.toDouble();
      final diastolic = (data['diastolic'] as num).toDouble();
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
        title: const Text('Huyết áp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
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
            const Row(
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
            const SizedBox(height: 16),
            const DefaultTabController(
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
            _buildBloodPressureSection(),
            _buildHeartRateSection(),
            const SizedBox(height: 16),

            // Chỉ hiển thị 1 mục gần nhất
            Expanded(
              child: _latestBloodPressureData != null
                  ? _buildLatestCard(context, _latestBloodPressureData!)
                  : _buildEmptyLatestCard(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressureScreen(userId: widget.userId),
            ),
          );
          // if (result != null) {
          //   setState(() {
          //     _latestBloodSugarData = result;
          //     _fetchBloodSugarTrendData();
          //   });
          // }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
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
            const Text('Gần nhất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Chưa có dữ liệu huyết áp. Vui lòng nhập để theo dõi tình trạng.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to blood pressure input screen
              },
              icon: const Icon(Icons.add),
              label: const Text('Nhập chỉ số'),
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
    final double systolic = (data['systolic'] as num).toDouble();
    final double diastolic = (data['diastolic'] as num).toDouble();
    String statusText;
    Color textColor;
    Color backgroundColor;

    if (systolic < 90) {
      if (diastolic < 90) {
        statusText = 'Thấp';
        textColor = Colors.orange;
        backgroundColor = Colors.orange.shade100;
      } else if (diastolic >= 90 && diastolic < 100) {
        statusText = 'Tăng huyết áp độ 1';
        textColor = Colors.red;
        backgroundColor = Colors.red.shade100;
      } else if (diastolic >= 100 && diastolic < 110) {
        statusText = 'Tăng huyết áp độ 2';
        textColor = Colors.red[700]!;
        backgroundColor = Colors.red.shade100;
      } else {
        statusText = 'Tăng huyết áp độ 3';
        textColor = Colors.red[900]!;
        backgroundColor = Colors.red.shade100;
      }
    } else if (systolic >= 90 && systolic < 100) {
      if (diastolic > 90 && diastolic < 100) {
        statusText = 'Tăng huyết áp độ 1';
        textColor = Colors.red;
        backgroundColor = Colors.red.shade100;
      } else if (diastolic >= 100 && diastolic < 110) {
        statusText = 'Tăng huyết áp độ 2';
        textColor = Colors.red[700]!;
        backgroundColor = Colors.red.shade100;
      } else if (diastolic >= 110) {
        statusText = 'Tăng huyết áp độ 3';
        textColor = Colors.red[900]!;
        backgroundColor = Colors.red.shade100;
      } else {
        statusText = 'Bình thường';
        textColor = Colors.green;
        backgroundColor = Colors.green.shade100;
      }
    } else if (systolic >= 100 && systolic < 130) {
      if (diastolic > 110) {
        statusText = 'Tăng huyết áp độ 3';
        textColor = Colors.red[900]!;
        backgroundColor = Colors.red.shade100;
      } else {
        statusText = 'Bình thường';
        textColor = Colors.green;
        backgroundColor = Colors.green.shade100;
      }
    } else if (systolic >= 130 && systolic < 140) {
      statusText = 'Bình thường cao';
      textColor = Colors.green[900]!;
      backgroundColor = Colors.green.shade100;
    } else if (systolic >= 140 && systolic < 160) {
        statusText = 'Tăng huyết áp độ 1';
        textColor = Colors.red;
        backgroundColor = Colors.red.shade100;
    } else if (systolic >= 160 && systolic < 180) {
        statusText = 'Tăng huyết áp độ 2';
        textColor = Colors.red[700]!;
        backgroundColor = Colors.red.shade100;
    } else if (systolic >= 180) {
      statusText = 'Tăng huyết áp độ 3';
      textColor = Colors.red[900]!;
      backgroundColor = Colors.red.shade100;
    } else {
      statusText = 'Không xác định';
      textColor = Colors.grey;
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
            const Text('Gần nhất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${systolic.toStringAsFixed(0)}/$diastolic mmHg', // Hiển thị đúng giá trị
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            const SizedBox(height: 8),
            Text('${data['time']}, ${data['moment']}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
            const Text('Tần suất phân bố', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
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

  Widget _buildMinAvgMaxCard(String title, double? value1, double? value2, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value1 != null && value2 != null
              ? '${value1.toStringAsFixed(0)}/${value2.toStringAsFixed(0)} mmHg'
              : value1 != null
              ? value1.toStringAsFixed(0)
              : '--', // Default to '--' if no value
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }


  Widget _buildBloodPressureSection() {
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
            const Text('Huyết áp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMinAvgMaxCard('Thấp nhất', _minSystolic, _minDiastolic, Colors.orange),
                _buildMinAvgMaxCard('Cao nhất', _maxSystolic, _maxDiastolic, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartRateSection() {
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
            const Text('Nhịp tim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMinAvgMaxCard('Thấp nhất', _minHeartRate, null, Colors.blue),
                _buildMinAvgMaxCard('Trung bình', _avgHeartRate, null, Colors.green),
                _buildMinAvgMaxCard('Cao nhất', _maxHeartRate, null, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }


}