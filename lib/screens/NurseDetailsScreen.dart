import 'package:flutter/material.dart';
import 'package:sakhi/models/nurses.dart';

class NurseDetailsScreen extends StatelessWidget {
  final Nurse nurse;

  const NurseDetailsScreen({Key? key, required this.nurse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${nurse.name}'),
            Text('Phone Number: ${nurse.phoneNumber}'),
            Text('Email: ${nurse.email}'),
            Text('Country: ${nurse.country}'),
            Text('State: ${nurse.state}'),
            Text('City: ${nurse.city}'),
            Text('Gender: ${nurse.gender}'),
            Text('LGBTQ Friendly: ${nurse.lgbtqSupported ? 'Yes' : 'No'}'),
            // Add logic to display gender-specific image here
          ],
        ),
      ),
    );
  }
}
