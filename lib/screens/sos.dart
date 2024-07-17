// main_screen.dart

import 'package:flutter/material.dart';
import 'sos_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  void _showSosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('SOS'),
        content: Text('Choose an option'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SosSettingsScreen()),
              );
            },
            child: Text('SOS Settings'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? sosNumber = prefs.getString('sosNumber');
              if (sosNumber != null) {
                final Uri url = Uri(
                  scheme: 'sms',
                  path: sosNumber,
                  queryParameters: <String, String>{
                    'body': 'Your Alzeimer suffering friend is in danger, help me!!',
                  },
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not send SOS message'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('SOS number not set'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Send SOS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSosDialog(context),
          child: Text('SOS'),
        ),
      ),
    );
  }
}
