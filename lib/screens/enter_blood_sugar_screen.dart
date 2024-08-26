import 'package:diabetes_app/database.dart';
import 'package:flutter/material.dart';

class EnterBloodSugarScreen extends StatefulWidget {
  final int userId;

  EnterBloodSugarScreen({required this.userId});

  @override
  _EnterBloodSugarScreenState createState() => _EnterBloodSugarScreenState();
}

class _EnterBloodSugarScreenState extends State<EnterBloodSugarScreen> {
  double _bloodSugar = 0.0;
  bool _isEditing = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedMeal = 'Trước ăn trưa';
  String _note = ''; // Biến để lưu ghi chú

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
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                ),
              ),
            );
          },
        );
      },
    );
    if (picked != null)
      setState(() {
        _selectedMeal = picked;
      });
  }

  Future<void> _saveBloodSugarData() async {
    final dbHelper = DatabaseHelper.instance;

    Map<String, dynamic> bloodSugarData = {
      'user_id': widget.userId,
      'level': _bloodSugar,
      'date': '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
      'time': '${_selectedTime.hour}:${_selectedTime.minute}',
      'moment': _selectedMeal,
      'note': _note,
    };

    await dbHelper.insertBloodSugar(bloodSugarData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dữ liệu đường huyết đã được lưu.')),
    );

    Navigator.of(context).pop(bloodSugarData);
  }


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
                      onChanged: (value) {
                        setState(() {
                          _note = value;
                        });
                      },
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
              onPressed: _saveBloodSugarData,
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodSugarLabel() {
    String prefix = 'Mức đường huyết ';
    TextStyle labelStyle;

    String labelText;
    if (_bloodSugar <= 55) {
      labelText = 'rất thấp';
      labelStyle = TextStyle(color: Colors.orange, fontSize: 24);
    } else if (_bloodSugar >= 56 && _bloodSugar <= 70) {
      labelText = 'thấp';
      labelStyle = TextStyle(color: Colors.yellow[700], fontSize: 24);
    } else if (_bloodSugar >= 71 && _bloodSugar <= 130) {
      labelText = 'bình thường';
      labelStyle = TextStyle(color: Colors.green, fontSize: 24);
    } else if (_bloodSugar >= 131 && _bloodSugar <= 250) {
      labelText = 'cao';
      labelStyle = TextStyle(color: Colors.red, fontSize: 24);
    } else {
      labelText = 'rất cao';
      labelStyle = TextStyle(color: Colors.red[900], fontSize: 24);
    }

    return RichText(
      text: TextSpan(
        text: prefix,
        style: TextStyle(color: Colors.black, fontSize: 24), // Uncolored prefix
        children: [
          TextSpan(text: labelText, style: labelStyle), // Colored label
        ],
      ),
    );
  }


  Color _getBloodSugarLevelColor() {
    if (_bloodSugar <= 55) {
      return Colors.orange;
    } else if (_bloodSugar >= 56 && _bloodSugar <= 70) {
      return Colors.yellow;
    } else if (_bloodSugar >= 71 && _bloodSugar <= 130) {
      return Colors.green;
    } else if (_bloodSugar >= 131 && _bloodSugar <= 250) {
      return Colors.red;
    } else if (_bloodSugar >= 251) {
      return Colors.red[900]!;
    } else {
      return Colors.grey;
    }
  }

  Widget _buildBloodSugarLevelBar() {
    return LinearProgressIndicator(
      value: _bloodSugar / 300,
      color: _getBloodSugarLevelColor(),
      backgroundColor: Colors.grey[300],
      minHeight: 8,
    );
  }
}
