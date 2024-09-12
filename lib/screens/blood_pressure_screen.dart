import 'package:diabetes_app/database.dart';
import 'package:diabetes_app/screens/blood_pressure_result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BloodPressureScreen extends StatefulWidget {
  final int userId;

  BloodPressureScreen({required this.userId});

  @override
  _BloodPressureScreenState createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  TextEditingController systolicController = TextEditingController();
  TextEditingController diastolicController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String _selectedMeal = 'Trước ăn trưa';

  double systolic = 0;
  double diastolic = 0;

  // Flag to indicate if there's a significant difference
  bool isDifferenceUnsafe = false;

  @override
  void initState() {
    super.initState();
    systolicController.text = '';
    diastolicController.text = '';
    heartRateController.text = '';
    DateTime now = DateTime.now();
    dateController.text = "${now.year}/${now.month}/${now.day}";
    timeController.text = "${now.hour}:${now.minute}";
    _updatePressureLevel();
  }

  void _updatePressureLevel() {
    setState(() {
      systolic = (double.tryParse(systolicController.text) ?? 0.0).clamp(0, 185);
      diastolic = (double.tryParse(diastolicController.text) ?? 0.0).clamp(0, 185);
      _checkLevelDifference();
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

  // Function to determine the level based on systolic value
  int _getSystolicLevel() {
    if (systolic < 90) {
      return 1; // Thấp
    } else if (systolic >= 90 && systolic <= 130) {
      return 2; // Bình thường
    } else if (systolic > 130 && systolic <= 140) {
      return 3; // Bình thường cao
    } else if (systolic > 140 && systolic <= 160) {
      return 4; // Tăng huyết áp độ 1
    } else if (systolic > 160 && systolic <= 180) {
      return 5; // Tăng huyết áp độ 2
    } else if (systolic > 180) {
      return 6; // Tăng huyết áp độ 3
    } else {
      return 0; // Không xác định
    }
  }

  // Function to determine the level based on diastolic value
  int _getDiastolicLevel() {
    if (diastolic < 60) {
      return 1; // Thấp
    } else if (diastolic >= 60 && diastolic <= 85) {
      return 2; // Bình thường
    } else if (diastolic > 85 && diastolic <= 90) {
      return 3; // Bình thường cao
    } else if (diastolic > 90 && diastolic <= 100) {
      return 4; // Tăng huyết áp độ 1
    } else if (diastolic > 100 && diastolic <= 110) {
      return 5; // Tăng huyết áp độ 2
    } else if (diastolic > 110) {
      return 6; // Tăng huyết áp độ 3
    } else {
      return 0; // Không xác định
    }
  }

  void _checkLevelDifference() {
    int systolicLevel = _getSystolicLevel();
    int diastolicLevel = _getDiastolicLevel();

    if (systolicLevel == 0 || diastolicLevel == 0) {
      isDifferenceUnsafe = false;
      return;
    }

    int difference = (systolicLevel - diastolicLevel).abs();

    if (difference > 1 || (systolic >= 140 && diastolic >= 90)) {
      isDifferenceUnsafe = true;
    } else {
      isDifferenceUnsafe = false;
    }
  }


  String _getBloodPressureLabel() {
    if (systolic < 90) {
      if (diastolic < 90) {
        return 'Thấp';
      } else if (diastolic >= 90 && diastolic < 100) {
        return 'Tăng huyết áp độ 1';
      } else if (diastolic >= 100 && diastolic < 110) {
        return 'Tăng huyết áp độ 2';
      } else {
        return 'Tăng huyết áp độ 3';
      }
    } else if (systolic >= 90 && systolic < 100) {
      if (diastolic > 90 && diastolic < 100) {
        return 'Tăng huyết áp độ 1';
      } else if (diastolic >= 100 && diastolic < 110) {
        return 'Tăng huyết áp độ 2';
      } else if (diastolic >= 110) {
        return 'Tăng huyết áp độ 3';
      } else {
        return 'Bình thường';
      }
    } else if (systolic >= 100 && systolic < 130) {
      if (diastolic > 110) {
        return 'Tăng huyết áp độ 3';
      } else {
        return 'Bình thường';
      }
    } else if (systolic >= 130 && systolic < 140) {
      return 'Bình thường cao';
    } else if (systolic >= 140 && systolic < 160) {
      return 'Tăng huyết áp độ 1';
    } else if (systolic >= 160 && systolic < 180) {
      return 'Tăng huyết áp độ 2';
    } else if (systolic >= 180) {
      return 'Tăng huyết áp độ 3';
    } else {
      return 'Không xác định';
    }
  }

  Color _getBloodPressureColor() {
    // if (systolic < 90 && diastolic < 60) {
    //   return Colors.orange;
    // } else if (systolic >= 90 && systolic <= 130 && diastolic >= 60 && diastolic <= 85) {
    //   return Colors.green;
    // } else if (systolic > 130 && systolic <= 140 && diastolic > 85 && diastolic <= 90) {
    //   return Colors.green[900]!;
    // } else if (systolic > 140 && systolic <= 160 && diastolic > 90 && diastolic <= 100) {
    //   return Colors.red;
    // } else if (systolic > 160 && systolic <= 180 && diastolic > 100 && diastolic <= 110) {
    //   return Colors.red[700]
    // } else if (systolic > 180 && diastolic > 110) {
    //   return Colors.red[900]!;
    // } else {
    //   return Colors.grey;
    // }
    if (systolic < 90) {
      if (diastolic < 90) {
        return Colors.orange;
      } else if (diastolic >= 90 && diastolic < 100) {
        return Colors.red;
      } else if (diastolic >= 100 && diastolic < 110) {
        return Colors.red[700]!;
      } else {
        return Colors.red[900]!;
      }
    } else if (systolic >= 90 && systolic < 100) {
      if (diastolic > 90 && diastolic < 100) {
        return Colors.red;
      } else if (diastolic >= 100 && diastolic < 110) {
        return Colors.red[700]!;
      } else if (diastolic >= 110) {
        return Colors.red[900]!;
      } else {
        return Colors.green;
      }
    } else if (systolic >= 100 && systolic < 130) {
      if (diastolic > 110) {
        return Colors.red[900]!;
      } else {
        return Colors.green;
      }
    } else if (systolic >= 130 && systolic < 140) {
      return Colors.green[900]!;
    } else if (systolic >= 140 && systolic < 160) {
      return Colors.red;
    } else if (systolic >= 160 && systolic < 180) {
      return Colors.red[700]!;
    } else if (systolic >= 180) {
      return Colors.red[900]!;
    } else {
      return Colors.grey;
    }
  }

  Widget _buildBloodPressureLabel() {
    String prefix = 'Huyết áp đang ở mức ';
    String labelText = _getBloodPressureLabel();
    Color labelColor = _getBloodPressureColor();

    return RichText(
      text: TextSpan(
        text: prefix,
        style: TextStyle(color: Colors.black, fontSize: 24),
        children: [
          TextSpan(text: labelText, style: TextStyle(color: labelColor, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildBloodPressureLevelBar() {
    double value = (systolic > diastolic) ? systolic / 185 : diastolic / 185;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: value,
          color: _getBloodPressureColor(),
          backgroundColor: Colors.grey[300],
          minHeight: 8,
        ),
        SizedBox(height: 8),
        // Conditionally show the error message
        if (isDifferenceUnsafe)
          Text(
            'Chỉ số huyết áp trong ngưỡng không an toàn. Vui lòng kiểm tra lại hoặc cho biết lí do.',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập chỉ số huyết áp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBloodPressureInput(),
              SizedBox(height: 16),
              _buildHeartRateInput(),
              SizedBox(height: 16),
              _buildDateTimeInput(),
              SizedBox(height: 16),
              _buildMealInput(),
              SizedBox(height: 16),
              _buildNoteInput(),
              SizedBox(height: 16),
              _buildNote(),
              SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodPressureInput() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_heart_outlined),
                SizedBox(width: 5),
                Text('Tâm thu / Tâm trương',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPressureTextField(systolicController, 'Tâm thu'),
                Text('/'),
                _buildPressureTextField(diastolicController, 'Tâm trương'),
                Text('mmHg'),
              ],
            ),
            SizedBox(height: 10),
            _buildBloodPressureLabel(),
            SizedBox(height: 10),
            _buildBloodPressureLevelBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureTextField(TextEditingController controller, String label) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
          _MaxValueInputFormatter(350),
        ],
        onChanged: (value) {
          _updatePressureLevel();
        },
      ),
    );
  }

  Widget _buildHeartRateInput() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite_outline_rounded),
                SizedBox(width: 5),
                Text('Nhịp tim',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: heartRateController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                suffixText: 'lần/phút',
                suffixStyle: TextStyle(color: Colors.black, fontSize: 18),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDateTimeInput() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (pickedTime != null) {
            setState(() {
              dateController.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              timeController.text =
              "${pickedTime.hour}:${pickedTime.minute}";
            });
          }
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 5),
                  Text('Ngày và giờ',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${dateController.text} ${timeController.text}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealInput() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined),
                SizedBox(width: 5),
                Text('Thời điểm đo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectMeal(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedMeal, style: TextStyle(fontSize: 16)),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sticky_note_2_outlined),
                SizedBox(width: 5),
                Text('Ghi chú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Card(
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
                      text: 'Các ngưỡng huyết áp (mmHg): ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '\n- Huyết áp thấp: Tâm thu < 90; Tâm trương < 60.\n'
                          '- Bình thường: Tâm thu 90 - 130; Tâm trương 60 - 85.\n'
                          '- Bình thường cao: Tâm thu 130 - 140; Tâm trương 85 - 90.\n'
                          '- Tăng huyết áp độ 1: Tâm thu 140 - 160; Tâm trương 90 - 100.\n'
                          '- Tăng huyết áp độ 2: Tâm thu 160 - 180; Tâm trương 100 - 110.\n'
                          '- Tăng huyết áp độ 3: Tâm thu > 180; Tâm trương > 110.\n\n',
                    ),
                    TextSpan(
                      text: 'Nhịp tim:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '\n Theo Hiệp hội Tim mạch Hoa Kỳ, nhịp tim bình thường của người'
                          'trưởng thành là khoảng 60 - 100 bpm lúc nghỉ ngơi. Tuy nhiên khi ngủ,'
                          ' nhịp tim có xu hướng chậm đi (40 - 50 bpm). \n\n',
                    ),
                    TextSpan(
                      text: 'Nhịp tim cao: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '> 100 nhịp/phút ở người trường thành. \n\n',
                    ),
                    TextSpan(
                      text: 'Nhịp tim thấp: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '< 60 nhịp/phút ở người trường thành.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // Kiểm tra nếu huyết áp không an toàn và chưa nhập lý do
          if (isDifferenceUnsafe && noteController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
              Text('Chỉ số huyết áp không an toàn. Vui lòng cho biết lí do.'),
              backgroundColor: Colors.red,
            ));
            return;
          }

          // Chuyển đổi systolic, diastolic, và heartRate sang số nguyên
          int systolic = int.tryParse(systolicController.text) ?? 0;
          int diastolic = int.tryParse(diastolicController.text) ?? 0;
          int pulse = int.tryParse(heartRateController.text) ?? 0; // Nhịp tim

          // Kiểm tra nếu dữ liệu đầu vào hợp lệ
          if (systolic == 0 || diastolic == 0 || pulse == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Vui lòng nhập đầy đủ chỉ số huyết áp và nhịp tim.'),
              backgroundColor: Colors.red,
            ));
            return;
          }

          // Lưu dữ liệu huyết áp vào SQLite database
          await DatabaseHelper.instance.insertBloodPressure({
            'user_id': widget.userId, // ID của người dùng
            'systolic': systolic, // Chỉ số tâm thu
            'diastolic': diastolic, // Chỉ số tâm trương
            'pulse': pulse, // Nhịp tim
            'date': dateController.text, // Ngày đo
            'time': timeController.text, // Thời gian đo
            'moment': _selectedMeal, // Thời điểm đo (ví dụ: Trước ăn trưa)
            'note': noteController.text, // Ghi chú (nếu có)
          });

          // Hiển thị thông báo lưu thành công
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Dữ liệu huyết áp đã được lưu thành công.'),
            backgroundColor: Colors.green,
          ));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressureResultScreen(userId: widget.userId),
            ),
          );
        },
        child: Text('Lưu'),
      ),
    );
  }
}

// Custom TextInputFormatter to limit the maximum value
class _MaxValueInputFormatter extends TextInputFormatter {
  final int max;

  _MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value > max) {
      return oldValue;
    }

    return newValue;
  }
}
