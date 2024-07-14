import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';

class ButtonScreen extends ConsumerStatefulWidget {
  const ButtonScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ButtonScreenState();
  }
}

class _ButtonScreenState extends ConsumerState<ButtonScreen> {
  bool _isAlarmEnabled = false;
  Timer? _timer;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Ensure this icon exists

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid && Platform.version.contains('33')) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.requestPermission();
      if (granted != null && !granted) {
        print("Notification permission denied");
      }
    }
  }

  void _scheduleAlarm() {
    print("Scheduling alarm"); // Debug print
    _timer?.cancel(); // Cancel any existing timer
    if (_isAlarmEnabled) {
      _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
        print("Timer triggered"); // Debug print
        _showNotification();
      });
    }
  }

  Future<void> _showNotification() async {
    print("Attempting to show notification"); // Debug print
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Channel',
      channelDescription: 'This channel is used for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Alarm',
      'Dont Forget to Check your Bestie ~ Team Sakhi',
      platformChannelSpecifics,
    );
    print("Notification shown"); // Debug print
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 204, 216),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 100.0), // Adjust the top padding as needed
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20.0, // Adjust spacing between buttons
              runSpacing: 50.0, // Adjust spacing between rows
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/places');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120, // Adjust size as needed
                        height: 160, // Adjust size as needed
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/assets/findway.png'), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // Adjust spacing between image and text
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/nurseList');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120, // Adjust size as needed
                        height: 160, // Adjust size as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/assets/medicine.png'), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // Adjust spacing between image and text
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120, // Adjust size as needed
                        height: 160, // Adjust size as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/assets/appointment.png'), // Replace with your image path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // Adjust spacing between image and text
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // No specific action required when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    primary: Colors.black, // Background color of the button
                  ),
                  child: Container(
                    width: 120, // Adjust size as needed
                    height: 168, // Adjust size as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Enable Alarm',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white), // Text color
                          ),
                          Switch(
                            value: _isAlarmEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isAlarmEnabled = value;
                              });
                              _scheduleAlarm();
                            },
                            activeColor:
                                Colors.blue, // Color of the active switch
                            inactiveTrackColor: Colors
                                .grey, // Color of the inactive switch track
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
