import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';
import '../l10n.dart'; // Import your localization class

class ButtonScreen extends ConsumerStatefulWidget {
  final void Function(Locale) setLocale;

  const ButtonScreen({super.key, required this.setLocale});

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
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
      appBar: AppBar(
        title: Text( AppLocalizations.of(context).translate('buttonScreenTitle')),
        actions: [
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            icon: const Icon(Icons.language),
            onChanged: (Locale? newValue) {
              if (newValue != null) {
                widget.setLocale(newValue);
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English',style: const TextStyle(color: Colors.black)),
              ),
              DropdownMenuItem(
                value: Locale('de'),
                child:  Text('German',style: const TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 227, 204, 216),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20.0,
              runSpacing: 50.0,
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/findway.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                         AppLocalizations.of(context).translate('findWay'),
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/medicine');
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/medicine.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                                                AppLocalizations.of(context).translate('medicine'),

                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/people');
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/people.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                                                 AppLocalizations.of(context).translate('people'),

                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/appointment.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                                                 AppLocalizations.of(context).translate('nurseList'),

                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/sos');
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/sos.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                                                AppLocalizations.of(context).translate('sos'),

                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/chat');
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
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: const DecorationImage(
                            image: AssetImage('lib/assets/chat-image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                                                 AppLocalizations.of(context).translate('chat'),

                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
                    width: 100, // Adjust size as needed
                    height: 157, // Adjust size as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            AppLocalizations.of(context).translate('Enable Alarm'),
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
