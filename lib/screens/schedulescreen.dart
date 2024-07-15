import 'package:flutter/material.dart';
import 'package:sakhi/models/medicine.dart';
import 'package:sakhi/providers/medicine_db.dart';
import 'package:intl/intl.dart';
import 'package:sakhi/screens/addmedicine.dart';
import 'package:sakhi/screens/medicine_details_screen.dart'; // Import the new detail page
import 'dart:io';

class MedicineCalendarPage extends StatefulWidget {
  @override
  _MedicineCalendarPageState createState() => _MedicineCalendarPageState();
}

class _MedicineCalendarPageState extends State<MedicineCalendarPage> {
  String _selectedDay =
      DateFormat('EEEE').format(DateTime.now()); // Default to current day
  List<String> _daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  Future<void> _navigateToAddMedicinePage() async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicinePage(daysOfWeek: _daysOfWeek),
      ),
    );
    if (result == true) {
      // Refresh the calendar page if a new medicine was added
      setState(() {});
    }
  }

  void _navigateToMedicineDetailPage(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDetailPage(medicine: medicine),
      ),
    ).then((value) {
      if (value == true) {
        // Refresh the calendar page if a medicine was deleted
        setState(() {});
      }
    });
  }

  Future<void> _confirmDeleteMedicine(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this medicine?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await DatabaseHelper().deleteMedicine(id);
                Navigator.of(context).pop(true); // Return true on delete
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {}); // Refresh the UI after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Calendar'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: _selectedDay,
              dropdownColor:
                  Colors.white, // White background for dropdown items
              style: TextStyle(color: Colors.black), // Black text color
              icon: Icon(Icons.arrow_drop_down,
                  color: Colors.black), // Black arrow
              items: _daysOfWeek.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black), // Black text color
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Medicine>>(
              future: DatabaseHelper().getMedicineList(_selectedDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No medicines scheduled for $_selectedDay'));
                } else {
                  List<Medicine> medicines = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      Medicine medicine = medicines[index];
                      return GestureDetector(
                        onTap: () => _navigateToMedicineDetailPage(medicine),
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                'Name: ${medicine.name}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: medicine.photoPath.isNotEmpty
                                      ? Image.file(
                                          File(medicine.photoPath),
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.camera_alt, size: 40),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text('Times: ${medicine.timesToTake.join(', ')}'),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () =>
                                    _confirmDeleteMedicine(medicine.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMedicinePage,
        child: Icon(Icons.add),
      ),
    );
  }
}
