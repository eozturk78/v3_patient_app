import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/screens/agreements/agreements.dart';
import 'package:patient_app/screens/agreements/edit-agreements.dart';
import 'package:patient_app/screens/agreements/privacy-policy.dart';
import 'package:patient_app/screens/agreements/terms-and-conditions.dart';
import 'package:patient_app/screens/communication/calendar.dart';
import 'package:patient_app/screens/communication/chat.dart';
import 'package:patient_app/screens/communication/communication.dart';
import 'package:patient_app/screens/communication/medical-plan-1.dart';
import 'package:patient_app/screens/communication/messages.dart';
import 'package:patient_app/screens/description/blutdruck-description.dart';
import 'package:patient_app/screens/description/pulse-description.dart';
import 'package:patient_app/screens/description/saturation-description.dart';
import 'package:patient_app/screens/description/temperature-description.dart';
import 'package:patient_app/screens/description/weight-description.dart';
import 'package:patient_app/screens/home/home.dart';
import 'package:patient_app/screens/info/documents-details.dart';
import 'package:patient_app/screens/info/documents.dart';
import 'package:patient_app/screens/info/enlightenment.dart';
import 'package:patient_app/screens/info/info.dart';
import 'package:patient_app/screens/info/libraries.dart';
import 'package:patient_app/screens/login/change-password.dart';
import 'package:patient_app/screens/login/login.dart';
import 'package:patient_app/screens/main-menu/main-menu.dart';
import 'package:patient_app/screens/main-menu/main-sub-menu.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-blutdruck.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-pulse.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-saturation.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-temperature.dart';
import 'package:patient_app/screens/measurement-result/measurement-result-weight.dart';
import 'package:patient_app/screens/medication/medication-plan-list.dart';
import 'package:patient_app/screens/medication/medication.dart';
import 'package:patient_app/screens/medication/recipes.dart';
import 'package:patient_app/screens/profile/about-me/about-me.dart';
import 'package:patient_app/screens/profile/profile.dart';
import 'package:patient_app/screens/questionnaire-group/questionnaire-group.dart';
import 'package:patient_app/screens/questionnaire-result/questionnaire-result.dart';
import 'package:patient_app/screens/questionnaire-result/send-result.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-1.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-2.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-3.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-4.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-5.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-6.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-7.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-8.dart';
import 'package:patient_app/screens/questionnaire/questionnaire-9.dart';
import 'package:patient_app/screens/quick-access/quick-access.dart';
import 'package:patient_app/screens/redirection/redirection.dart';
import 'package:patient_app/screens/registration/registration-completed.dart';
import 'package:patient_app/screens/registration/registration-1.dart';
import 'package:patient_app/screens/registration/registration-2.dart';
import 'package:patient_app/screens/registration/registration-3.dart';
import 'package:patient_app/screens/registration/registration-4.dart';
import 'package:patient_app/screens/settings/settings.dart';
import 'package:patient_app/screens/shared/customized_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/shared.dart';
import '../screens/main-menu/route_util.dart';

import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // For Android, create an Android Initialization Settings object
  AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@drawable/ic_launcher');

  // For iOS, create an IOS Initialization Settings object
  IOSInitializationSettings iosInitializationSettings =
  IOSInitializationSettings();

  // Initialize the settings for each platform
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  // Initialize the plugin with the settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission to receive notifications (optional)
  NotificationSettings settings = await messaging.requestPermission();

  // If permission is granted, get the FCM token
  String? token = await messaging.getToken();
  print('FCM Token: $token');


  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up foreground message handler
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;


    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              //icon: android?.smallIcon,
              //icon: "ic_notification",
                icon: '@drawable/ic_launcher',
              // other properties...
            ),
          ));
    }
  });
  runApp(const MyApp());
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Received background message: ${message.notification?.title}');
  //AwesomeNotificationsFCM().createNotificationFromJsonData(message.data);
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      title: 'iMedCom Patient App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      //home: const MyHomePage(title: 'iMedCom App Demo Home Page'),
      initialRoute: "/splash-screen",
      routes: {
        "/splash-screen": (context) => const MyHomePage(title: ''),
        "/main-menu": (context) => const MainMenuPage(),
        "/settings": (context) => const SettingsPage(),
        "/main-sub-menu": (context) => const MainSubMenuPage(),
        "/home": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        "/change-password": (context) => const ChangePasswordPage(),
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
        "/communication": (context) => const CommunicationPage(),
        "/info": (context) => const InfoPage(),
        "/medication": (context) => const MedicationPage(),
        "/quick-access": (context) => CustomizedMenuPage(),
        "/messages": (context) => const MessagesPage(),
        "/chat": (context) => const ChatPage(),
        "/medical-plan-1": (context) => const MedicalPlan1Page(),
        "/calendar": (context) => CalendarScreen(),
        "/medication-plan-list": (context) => const MedicationPlanListPage(),
        "/recipes": (context) => const RecipesPage(),
        "/libraries": (context) => const LibraryListPage(),
        "/enlightenment": (context) => const EnlightenmentPage(),
        "/documents": (context) => const DocumentListPage(),
        "/document-details": (context) => const DocumentDetailsPage(),
        "/questionnaire-1": (context) => const Questionnaire1Page(),
        "/questionnaire-2": (context) => const Questionnaire2Page(),
        "/questionnaire-3": (context) => const Questionnaire3Page(),
        "/questionnaire-4": (context) => const Questionnaire4Page(),
        "/questionnaire-5": (context) => const Questionnaire5Page(),
        "/questionnaire-6": (context) => const Questionnaire6Page(),
        "/questionnaire-7": (context) => const Questionnaire7Page(),
        "/questionnaire-8": (context) => const Questionnaire8Page(),
        "/questionnaire-9": (context) => const Questionnaire9Page(),
        "/blutdruck-description": (context) => const BlutdruckDescriptionPage(),
        "/weight-description": (context) => const WeightDescriptionPage(),
        "/saturation-description": (context) =>
            const SaturationDescriptionPage(),
        "/pulse-description": (context) => const PulseDescriptionPage(),
        "/temperature-description": (context) =>
            const TemperatureDescriptionPage(),
        "/about-me": (context) => const AboutMe(),
        "/registration-1": (context) => const Registration1Page(),
        "/registration-2": (context) => const Registration2Page(),
        "/registration-3": (context) => const Registration3Page(),
        "/registration-4": (context) => const Registration4Page(),
        "/created-account-successfully": (context) =>
            const RegistrationCompletedPage(),
        "/agreements": (context) => const AgreementsPage(),
        "/edit-agreements": (context) => const EditAgreementsPage(),
        "/redirection": (context) => const RedirectionPage(),
        "/questionnaire-group": (context) => const QuestionnaireGroupPage(),
        "/questionnaire-result": (context) => const QuestionnaireResultPage(),
        "/send-result": (context) => const SendResultPage(),
        "/privacy-policy": (context) => const PrivacyPolicyPage(),
        "/terms-and-conditions": (context) => const TermsAndConditionsPage(),
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(isLoggedIn) // prevent going to this screen with back button of android devices, if the user already logged in
        {
      Navigator.of(context).pushReplacementNamed("/main-menu");
    }
  }


  void initState() {
    super.initState();

      checkRedirection();
  }

/*
checkRedirection() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var isAgreementRead = Timer(
      Duration(seconds: 3),
      (() {
        if (pref.getBool('isAgreementRed') == true)
          Navigator.of(context).pushReplacementNamed("/login");
        else
          Navigator.of(context).pushReplacementNamed("/agreements");
      }),
    );
  }
*/

  checkRedirection() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

        if (pref.getBool('isAgreementRed') == true)
          Navigator.of(context).pushReplacementNamed("/login");
        else
          Navigator.of(context).pushReplacementNamed("/agreements");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Image.asset(
          "assets/images/logo-imedcom.png",
          width: 200,
          height: 100,
        ),])),
    );
  }
}