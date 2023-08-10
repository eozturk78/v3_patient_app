import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../communication/calendar.dart';
import '../communication/chat.dart';
import '../communication/communication.dart';
import '../communication/medical-plan-1.dart';
import '../communication/messages.dart';
import '../home/home.dart';
import '../info/documents-details.dart';
import '../info/documents.dart';
import '../info/enlightenment.dart';
import '../info/info.dart';
import '../info/libraries.dart';
import '../measurement-result/measurement-result-blutdruck.dart';
import '../measurement-result/measurement-result-pulse.dart';
import '../measurement-result/measurement-result-saturation.dart';
import '../measurement-result/measurement-result-temperature.dart';
import '../measurement-result/measurement-result-weight.dart';
import '../medication/medication-plan-list.dart';
import '../medication/medication.dart';
import '../medication/recipes.dart';
import '../profile/about-me/about-me.dart';
import '../profile/profile.dart';
import '../quick-access/quick-access.dart';
import '../settings/settings.dart';
import '../main-menu/main-menu.dart';

final Map<String, String> routeDisplayNames = {
  "/main-menu": "Main Menu",
  "/settings": "Settings",
  "/home": "Grafische Darstellungen",
  "/profile": "Profile",
  "/measurement-result": "Measurement Result",
  "/measurement-result-weight": "Measurement Result Weight",
  "/measurement-result-pulse": "Measurement Result Pulse",
  "/measurement-result-temperature": "Measurement Result Temperature",
  "/measurement-result-saturation": "Measurement Result Saturation",
  "/communication": "Communication",
  "/info": "Info",
  "/medication": "Medication",
  "/messages": "Messages",
  "/chat": "Chat",
  "/medical-plan-1": "Medical Plan 1",
  "/calendar": "Kalender",
  "/medication-plan-list": "Medication Plan List",
  "/recipes": "Recipes",
  "/libraries": "Libraries",
  "/enlightenment": "Enlightenment",
  "/documents": "Documents",
  "/document-details": "Document Details",
  "/about-me": "About Me",
  // ... Add other route display names here
};


Map<String, WidgetBuilder> allRoutes = {
  "/main-menu": (context) => const MainMenuPage(),
  "/settings": (context) => const SettingsPage(),
  "/home": (context) => const HomePage(),
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
  "/quick-access": (context) => const QuickAccessPage(),
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
  "/about-me": (context) => const AboutMe(),
};
