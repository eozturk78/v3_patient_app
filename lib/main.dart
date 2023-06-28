import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/comunication/calendar.dart';
import 'package:patient_app/screens/comunication/chat.dart';
import 'package:patient_app/screens/comunication/comunication.dart';
import 'package:patient_app/screens/comunication/medical-plan-1.dart';
import 'package:patient_app/screens/comunication/medical-plan-2.dart';
import 'package:patient_app/screens/comunication/messages.dart';
import 'package:patient_app/screens/home/home.dart';
import 'package:patient_app/screens/info/info.dart';
import 'package:patient_app/screens/login/login.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-blutdruck.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-pulse.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-saturation.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-temperature.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-weight.dart';
import 'package:patient_app/screens/medication/medication.dart';
import 'package:patient_app/screens/profile/profile.dart';
import 'package:patient_app/screens/quick-access/quick-access.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iMedCom Patient App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: "/splash-screen",
      routes: {
        "/splash-screen": (context) => const MyHomePage(title: ''),
        "/home": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        "/profile": (context) => const ProfilePage(),
        "/measurement-result": (context) => const MeasurementResultPage(),
        "/measurement-result-weight": (context) =>
            const MeasurementResultWeightPage(),
        "/measurement-result-pulse": (context) =>
            const MeasurementResultPulsePage(),
        "/measurement-result-temperature": (context) =>
            const MeasurementResultTemperaturePage(),
        "/measurement-result-saturation": (context) =>
            const MeasurementResultSaturationPage(),
        "/comunication": (context) => const ComunicationPage(),
        "/info": (context) => const InfoPage(),
        "/medication": (context) => const MedicationPage(),
        "/quick-access": (context) => const QuickAccessPage(),
        "/messages": (context) => const MessagesPage(),
        "/chat": (context) => const ChatPage(),
        "/medical-plan-1": (context) => const MedicalPlan1Page(),
        "/medical-plan-2": (context) => const MedicalPlan2Page(),
        "/calendar": (context) => const CalendarPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      (() {
        Navigator.of(context).pushReplacementNamed("/login");
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo-imedcom.png",
          width: 200,
          height: 100,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
