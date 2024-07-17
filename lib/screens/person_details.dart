import 'package:flutter/material.dart';
import 'package:sakhi/models/people.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class PersonDetailsPage extends StatelessWidget {
  final Person person;

  const PersonDetailsPage({Key? key, required this.person}) : super(key: key);

  Future<void> _copyAndCallPhoneNumber(BuildContext context, String phoneNumber) async {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Phone number copied to clipboard and calling'),
        duration: Duration(seconds: 2),
      ),
    );
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone dialer'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Name: ${person.name}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: person.photoPath.isNotEmpty
                      ? Image.file(
                          File(person.photoPath),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Relationship: ${person.relationship}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => _copyAndCallPhoneNumber(context, person.phoneNumber),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Colors.blue),
                      SizedBox(width: 8.0),
                      Text(
                        'Phone: ${person.phoneNumber}',
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Address: ${person.address}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
