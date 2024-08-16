import 'package:flutter/material.dart';

class EnterBloodSugarScreen extends StatefulWidget {
  @override
  _EnterBloodSugarScreenState createState() => _EnterBloodSugarScreenState();
}

class _EnterBloodSugarScreenState extends State<EnterBloodSugarScreen> {
  double _bloodSugar = 0.0;
  bool _isEditing = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedMeal = 'Trước ăn trưa';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  Future<void> _selectMeal(BuildContext context) async {
    final String? picked = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Thức giấc'),
              onTap: () => Navigator.pop(context, 'Thức giấc'),
            ),
            ListTile(
              title: Text('Trước ăn sáng'),
              onTap: () => Navigator.pop(context, 'Trước ăn sáng'),
            ),
            ListTile(
              title: Text('Sau ăn sáng'),
              onTap: () => Navigator.pop(context, 'Sau ăn sáng'),
            ),
            ListTile(
              title: Text('Trước ăn trưa'),
              onTap: () => Navigator.pop(context, 'Trước ăn trưa'),
            ),
            ListTile(
              title: Text('Sau ăn trưa'),
              onTap: () => Navigator.pop(context, 'Sau ăn trưa'),
            ),
            ListTile(
              title: Text('Trước ăn tối'),
              onTap: () => Navigator.pop(context, 'Trước ăn tối'),
            ),
            ListTile(
              title: Text('Sau ăn tối'),
              onTap: () => Navigator.pop(context, 'Sau ăn tối'),
            ),
            ListTile(
              title: Text('Trước tập thể dục'),
              onTap: () => Navigator.pop(context, 'Trước tập thể dục'),
            ),
            ListTile(
              title: Text('Sau tập thể dục'),
              onTap: () => Navigator.pop(context, 'Sau tập thể dục'),
            ),
            ListTile(
              title: Text('Giờ đi ngủ'),
              onTap: () => Navigator.pop(context, 'Giờ đi ngủ'),
            ),
            ListTile(
              title: Text('Nửa đêm'),
              onTap: () => Navigator.pop(context, 'Nửa đêm'),
            ),
          ],
        );
      },
    );
    if (picked != null)
      setState(() {
        _selectedMeal = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập chỉ số đường huyết'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_selectedTime.format(context)} - ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                        TextButton(
                          onPressed: () async {
                            await _selectDate(context);
                            await _selectTime(context);
                          },
                          child: Text('Chỉnh sửa'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedMeal),
                        TextButton(
                          onPressed: () => _selectMeal(context),
                          child: Text('Chỉnh sửa'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nhập ghi chú của bạn',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Card(
                      color: Colors.yellow[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Mức đường huyết bình thường: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '\n- Lúc đói: khoảng 70-130 mg/dL.\n'
                                          '- Sau ăn 2 tiếng rưỡi: khoảng < 180 mg/dL.\n'
                                          '- Bất kì lúc nào: khoảng < 180 mg/dL.\n\n',
                                    ),
                                    TextSpan(
                                      text: 'Mức được xem là hạ đường huyết: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '< 55 mg/dL\n\n',
                                    ),
                                    TextSpan(
                                      text: 'Mức được xem là tăng đường huyết: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '>= 300 mg/dL.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

    if (_bloodSugar < 56) {
      statusText = 'rất thấp';
      statusColor = Colors.orange;
    } else if (_bloodSugar >= 56 && _bloodSugar <= 70) {
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
    if (_bloodSugar < 56) {
      barColor = Colors.orange;
    } else if (_bloodSugar >= 56 && _bloodSugar <= 70) {
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
