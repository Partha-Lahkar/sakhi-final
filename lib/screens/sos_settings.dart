// sos_settings.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosSettingsScreen extends StatefulWidget {
  @override
  _SosSettingsScreenState createState() => _SosSettingsScreenState();
}

class _SosSettingsScreenState extends State<SosSettingsScreen> {
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSosNumber();
  }

  Future<void> _loadSosNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sosNumber = prefs.getString('sosNumber');
    if (sosNumber != null) {
      _phoneController.text = sosNumber;
    }
  }

  Future<void> _saveSosNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sosNumber', _phoneController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SOS number saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'SOS Helper Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveSosNumber,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
