import 'package:flutter/material.dart';
import 'package:sakhi/models/nurses.dart';
import 'package:url_launcher/url_launcher.dart';

class NurseDetailsScreen extends StatelessWidget {
  final Nurse nurse;

  const NurseDetailsScreen({Key? key, required this.nurse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nurse Details'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // White box container for nurse details
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gender-specific image centered with curved radius
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Image.asset(
                          nurse.gender == 'female'
                              ? 'lib/assets/female_image.png'
                              : 'lib/assets/male_image.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        if (nurse.lgbtqSupported)
                          Container(
                            margin: EdgeInsets.only(bottom: 8, right: 60),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('lib/assets/lgbt.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    nurse.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Phone Number: ${nurse.phoneNumber}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Country', nurse.country),
                      _buildDetailRow('State', nurse.state),
                      _buildDetailRow('City', nurse.city),
                      SizedBox(height: 8),
                      _buildDetailRow('Gender', nurse.gender),
                      _buildDetailRow('LGBTQ Friendly', nurse.lgbtqSupported ? 'Yes' : 'No'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _launchURL('https://www.dementiauk.org/home/contact-us/'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Make Appointment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '(Facility coming soon)',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String fieldName, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            fieldName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(width: 8),
          Text(
            detail,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
