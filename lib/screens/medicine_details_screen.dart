import 'package:flutter/material.dart';
import 'package:sakhi/models/medicine.dart';
import 'dart:io';

import 'package:sakhi/providers/medicine_db.dart';

class MedicineDetailPage extends StatelessWidget {
  final Medicine medicine;
  final Map<int, String> mymap = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
  };

  MedicineDetailPage({required this.medicine});

  void deleteMedicine(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete ${medicine.name} from schedule?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Perform delete operation
                // Example: DatabaseHelper().deleteMedicine(medicine.id);
                // Assuming DatabaseHelper is your class for database operations
                DatabaseHelper().deleteMedicine(medicine.id!);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to close detail page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteMedicine(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: screenHeight * 0.7,
          width: screenWidth * 0.9,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Medicine Name : " + medicine.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 60.0),
              Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.00)),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: medicine.photoPath.isNotEmpty
                    ? Image.file(
                        File(medicine.photoPath),
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.camera_alt, size: 60),
              ),
              SizedBox(height: 40.0),
              Text(
                'Days:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                spacing: 8.0,
                children: medicine.daysToTake
                    .map((day) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            mymap[day]!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Times:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                spacing: 8.0,
                children: medicine.timesToTake
                    .map((time) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
