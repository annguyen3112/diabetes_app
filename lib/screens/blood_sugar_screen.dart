import 'package:diabetes_app/database.dart';
import 'package:flutter/material.dart';
import 'enter_blood_sugar_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodSugarScreen extends StatefulWidget {
  final int userId;

  const BloodSugarScreen({super.key, required this.userId});

  @override
  _BloodSugarScreenState createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  Map<String, dynamic>? _latestBloodSugarData;
  double? _minLevel;
  double? _averageLevel;
  double? _maxLevel;
  List<FlSpot> _bloodSugarSpots = [];

  @override
  void initState() {
    super.initState();
    _fetchBloodSugarData();
    _fetchBloodSugarTrendData();
  }

  Future<void> _fetchBloodSugarData() async {
    final dbHelper = DatabaseHelper.instance;
    final latestData = await dbHelper.getLatestBloodSugar(widget.userId);
    final minLevel = await dbHelper.getMinBloodSugar(widget.userId);
    final averageLevel = await dbHelper.getAverageBloodSugar(widget.userId);
    final maxLevel = await dbHelper.getMaxBloodSugar(widget.userId);

    setState(() {
      _latestBloodSugarData = latestData;
      _minLevel = minLevel;
      _averageLevel = averageLevel;
      _maxLevel = maxLevel;
    });
  }

  Future<void> _fetchBloodSugarTrendData() async {
    final dbHelper = DatabaseHelper.instance;
    final bloodSugarData = await dbHelper.getBloodSugarData(widget.userId);

    List<FlSpot> spots = bloodSugarData.map<FlSpot>((data) {
      final date = DateTime.parse(data['date']);
      final dayOfMonth = date.day.toDouble();
      final level = data['level'] as double;
      return FlSpot(dayOfMonth, level);
    }).toList();

    setState(() {
      _bloodSugarSpots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đường huyết'),
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
            // Title and Options
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
            // Tab Bar
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
            const SizedBox(height: 16),
            // Content Area
            Expanded(
              child: ListView(
                children: [
                  if (_latestBloodSugarData != null)
                    _buildLatestCard(context, _latestBloodSugarData!)
                  else
                    FutureBuilder<Map<String, dynamic>?>(
                      future: DatabaseHelper.instance.getLatestBloodSugar(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
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
                  const SizedBox(height: 16),
                  _buildMinAvgMaxSection(),
                  const SizedBox(height: 16),
                  _buildTrendChart(),
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
              _fetchBloodSugarTrendData();
            });
          }
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
            const Text('Chưa có dữ liệu chỉ số đường huyết. Vui lòng nhập để theo dõi tình trạng bệnh.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterBloodSugarScreen(userId: widget.userId),
                  ),
                );
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
    final double level = data['level'];
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
            const Text('Gần nhất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$level mg/dL',
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinAvgMaxCard('Thấp nhất', _minLevel, Colors.orange),
        _buildMinAvgMaxCard('Trung bình', _averageLevel, Colors.green),
        _buildMinAvgMaxCard('Cao nhất', _maxLevel, Colors.red),
      ],
    );
  }

  Widget _buildMinAvgMaxCard(String label, double? value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                value != null ? '${value.toStringAsFixed(1)} mg/dL' : 'N/A',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biểu đồ xu hướng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 16),
          _bloodSugarSpots.isNotEmpty
              ? SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      final day = value.toInt();
                      return '$day';
                    },
                    reservedSize: 22,
                    margin: 8,
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      return '${value.toInt()}';
                    },
                    reservedSize: 28,
                    margin: 8,
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _bloodSugarSpots,
                    isCurved: true,
                    colors: [Colors.teal],
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          )
              : const Center(
            child: Text(
              'Chưa có đủ dữ liệu để hiển thị biểu đồ.',
              style: TextStyle(fontSize: 16, color: Colors.teal),
            ),
          ),
        ],
      ),
    );
  }

}
