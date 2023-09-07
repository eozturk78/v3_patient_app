import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import '../patient-contacts/contacts.dart';
import '../profile/about-me/about-me.dart';
import '../profile/profile.dart';
import '../quick-access/quick-access.dart';
import '../settings/settings.dart';
import '../main-menu/main-menu.dart';

class MenuSet {
  String? displayName;
  String? routerName;
  IconData? icon;
  MenuSet(this.displayName, this.icon);
}

final defaultMenuList = [
  "/profile",
  "/main-sub-menu",
  "/medication",
  "/messages",
  "/notification-history",
  "/info"
];

final Map<String, MenuSet> routeDisplayNames = {
  "/main-menu": MenuSet('Hauptmenü', Icons.abc),
  "/settings": MenuSet('Einstellungen', Icons.abc),
  "/home": MenuSet('Grafische Darstellungen', Icons.abc),
  "/profile": MenuSet('Profil', Icons.person_2_outlined),
  "/main-sub-menu": MenuSet('Daten', FontAwesomeIcons.fileMedical),
  "/measurement-result": MenuSet('Messergebnis', Icons.abc),
  "/measurement-result-weight":
      MenuSet('Gewicht des Messergebnisses', Icons.abc),
  "/measurement-result-pulse": MenuSet('Messergebnisimpuls', Icons.abc),
  "/measurement-result-temperature":
      MenuSet('Messergebnistemperatur', Icons.abc),
  "/measurement-result-saturation":
      MenuSet('Sättigung des Messergebnisses', Icons.abc),
  "/communication": MenuSet('Kommunikation', Icons.abc),
  "/info": MenuSet('Infothek', Icons.info_outline),
  "/medication": MenuSet('Medication', FontAwesomeIcons.kitMedical),
  "/messages": MenuSet('Nachrichten', FontAwesomeIcons.message),
  "/chat": MenuSet('Chat', Icons.abc),
  "/medical-plan-1": MenuSet('Medizinischer Plan', Icons.abc),
  "/calendar": MenuSet('Kalender', Icons.abc),
  "/medication-plan-list": MenuSet('Liste der Medikamentenpläne', Icons.abc),
  "/recipes": MenuSet('Rezepte', Icons.abc),
  "/libraries": MenuSet('Bibliotheken', Icons.abc),
  "/enlightenment": MenuSet('Erleuchtung', Icons.abc),
  "/documents": MenuSet('Dokumente', Icons.abc),
  "/document-details": MenuSet('Dokumentdetails', Icons.abc),
  "/about-me": MenuSet('Über mich', Icons.abc),
  "/patient-contacts-list": MenuSet('Meine medizinischen Kontakte', Icons.abc),
  "/notification-history": MenuSet('Erinnerungen', Icons.timer_sharp),

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
  "/measurement-result-pulse": (context) => const MeasurementResultPulsePage(),
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
  "/patient-contacts-list": (context) => ContactsListingPage(),
};
