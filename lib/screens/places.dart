import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakhi/providers/user_places.dart';
import 'package:sakhi/screens/add_place.dart';
import 'package:sakhi/widgets/places_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;
  bool _isAlarmEnabled = false;
  Timer? _timer;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadplaces();
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
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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
    final userplaces = ref.watch(userPlacesProvider);

    return Scaffold(
        appBar: AppBar(
          // add place button help
          title: const Text('Your Places'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddPlacescreen()));
              },
            ),
            Switch(
              value: _isAlarmEnabled,
              onChanged: (value) {
                setState(() {
                  _isAlarmEnabled = value;
                });
                _scheduleAlarm();
              },
            ),
          ],
        ),
        body: Padding(
          // for watching the places in the ui
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: _placesFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : PlacesList(
                          places: userplaces,
                        )),
        ));
  }
}
