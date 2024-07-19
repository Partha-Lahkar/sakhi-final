import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n.dart'; // Import localization setup
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sakhi/screens/ChatbotScreen.dart';
import 'package:sakhi/screens/NurseListScreen.dart';
import 'package:sakhi/screens/peoplelist.dart';
import 'package:sakhi/screens/places.dart';
import 'package:sakhi/screens/button_screen.dart';
import 'package:sakhi/screens/schedulescreen.dart';
import 'package:sakhi/screens/sos.dart';

import 'consts.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 255, 255, 255),
  background: Color.fromARGB(167, 139, 255, 123),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakhi',
      theme: theme,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('de', ''), // German
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      routes: {
        '/places': (context) => const PlacesScreen(),
        '/buttonScreen': (context) => ButtonScreen(setLocale: setLocale),
        '/nurseList': (context) => NurseListScreen(),
        '/medicine': (context) => MedicineCalendarPage(),
        '/chat': (context) => const ChatbotScreen(),
        '/people': (context) => PeopleListPage(),
        '/sos': (context) => MainScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/buttonScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
            'lib/assets/initialimage.png'), // Replace with your logo
      ),
    );
  }
}
