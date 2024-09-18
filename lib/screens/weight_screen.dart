import 'package:diabetes_app/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightScreen extends StatefulWidget {
  final int userId;

  WeightScreen({required this.userId});

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dateController.text = "${now.year}/${now.month}/${now.day}";
    timeController.text = "${now.hour}:${now.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập chỉ số cân nặng'),
      ),
      body: SingleChildScrollView(  // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildWeightInput(),
              SizedBox(height: 20),
              _buildHeightInput(),
              SizedBox(height: 20),
              _buildDateTimeInput(),
              SizedBox(height: 20),
              _buildNoteInput(),
              SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
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
                Icon(Icons.scale_outlined),
                SizedBox(width: 5),
                Text(
                  'Cân nặng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                suffix: Text(
                  'kg',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightInput() {
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
                Icon(Icons.height_outlined),
                SizedBox(width: 5),
                Text(
                  'Chiều cao',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                suffix: Text(
                  'cm',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
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

  Widget _buildSaveButton() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: () async {
          int weight = int.tryParse(_weightController.text) ?? 0;
          int height = int.tryParse(_heightController.text) ?? 0;

          if (weight == 0 || height == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Vui lòng nhập đầy đủ chỉ số chiều cao và cân nặng.'),
              backgroundColor: Colors.red,
            ));
            return;
          }

          await DatabaseHelper.instance.insertWeight({
            'user_id': widget.userId,
            'weight': weight,
            'height': height,
            'date': dateController.text,
            'time': timeController.text,
            'note': noteController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Dữ liệu cân nặng đã được lưu thành công.'),
            backgroundColor: Colors.green,
          ));
        },
        child: Text('Lưu'),
      ),
    );
  }
}
