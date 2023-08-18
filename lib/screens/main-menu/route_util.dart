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
  "/main-menu": "Hauptmenü",
  "/settings": "Einstellungen",
  "/home": "Grafische Darstellungen",
  "/profile": "Profil",
  "/measurement-result": "Messergebnis",
  "/measurement-result-weight": "Gewicht des Messergebnisses",
  "/measurement-result-pulse": "Messergebnisimpuls",
  "/measurement-result-temperature": "Messergebnistemperatur",
  "/measurement-result-saturation": "Sättigung des Messergebnisses",
  "/communication": "Kommunikation",
  "/info": "Info",
  "/medication": "Medikamente",
  "/messages": "Nachrichten",
  "/chat": "Chat",
  "/medical-plan-1": "Medizinischer Plan",
  "/calendar": "Kalender",
  "/medication-plan-list": "Liste der Medikamentenpläne",
  "/recipes": "Rezepte",
  "/libraries": "Bibliotheken",
  "/enlightenment": "Erleuchtung",
  "/documents": "Dokumente",
  "/document-details": "Dokumentdetails",
  "/about-me": "Über mich",
  "/patient-contacts-list": "Meine medizinischen Kontakte"

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
