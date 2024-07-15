import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakhi/models/medicine.dart';
import 'package:sakhi/providers/medicine_db.dart';

class AddMedicinePage extends StatefulWidget {
  final List<String> daysOfWeek;

  const AddMedicinePage({Key? key, required this.daysOfWeek}) : super(key: key);

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController _nameController = TextEditingController();
  List<String> _selectedDays = [];
  List<String> _timesToTake = [];
  File? _imageFile;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _addTime(TimeOfDay pickedTime) {
    setState(() {
      _timesToTake.add(pickedTime.format(context));
    });
  }

  Future<void> _saveMedicine() async {
    if (_nameController.text.isEmpty || _timesToTake.isEmpty || _selectedDays.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }

    List<int> daysToTake = [];
    _selectedDays.forEach((day) {
      int dayIndex = widget.daysOfWeek.indexOf(day);
      if (dayIndex != -1) {
        daysToTake.add(dayIndex);
      }
    });

    Medicine medicine = Medicine(
      name: _nameController.text,
      photoPath: _imageFile?.path ?? '',
      daysToTake: daysToTake,
      timesToTake: _timesToTake,
    );

    try {
      int result = await DatabaseHelper().insertMedicine(medicine);
      if (result != 0) {
        _showSnackBar('Medicine saved successfully!');
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        _showSnackBar('Failed to save medicine. Please try again.');
      }
    } catch (e) {
      print('Error saving medicine: $e');
      _showSnackBar('Error saving medicine. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Day(s):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: widget.daysOfWeek.map((day) {
                bool isSelected = _selectedDays.contains(day);
                return ElevatedButton(
                  onPressed: () => _toggleDay(day),
                  style: ElevatedButton.styleFrom(
                    primary: isSelected ? Colors.black : Colors.grey[700],
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(day),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Times to Take:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              children: _timesToTake.map((time) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(time),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  _addTime(pickedTime);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Add Time'),
            ),
            SizedBox(height: 16.0),
            _imageFile != null
                ? Image.file(_imageFile!, height: 100)
                : ElevatedButton(
                    onPressed: _takePicture,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Take Picture'),
                  ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMedicine,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Save Medicine'),
            ),
          ],
        ),
      ),
    );
  }
}
